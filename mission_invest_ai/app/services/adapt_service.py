from datetime import datetime, timedelta
from ..schemas.adapt import AdaptRequest, AdaptResponse


def generate_adaptation(req: AdaptRequest) -> AdaptResponse:
    """Suggest mission adaptation based on current progress."""
    remaining = req.target_amount - req.current_saved

    if remaining <= 0:
        return AdaptResponse(
            suggestion="on_track",
            reasoning="Mission is already fully funded!",
        )

    if req.days_left <= 0:
        return AdaptResponse(
            suggestion="extend_timeline",
            new_daily_amount=req.daily_target,
            new_end_date=(datetime.now() + timedelta(days=14)).date().isoformat(),
            reasoning="Mission deadline has passed. Extending by 14 days to complete.",
        )

    actual_daily_needed = remaining / req.days_left

    # If actual daily needed is more than 1.5x the original target
    if actual_daily_needed > req.daily_target * 1.5:
        # Suggest extending timeline
        comfortable_days = int(remaining / req.daily_target) + 1
        new_end = (datetime.now() + timedelta(days=comfortable_days)).date().isoformat()
        return AdaptResponse(
            suggestion="extend_timeline",
            new_daily_amount=req.daily_target,
            new_end_date=new_end,
            reasoning=(
                f"At ₹{req.daily_target:.0f}/day, you need {comfortable_days} more days. "
                f"Current pace requires ₹{actual_daily_needed:.0f}/day which is too aggressive."
            ),
        )

    # If actual daily is slightly higher, suggest reducing
    if actual_daily_needed > req.daily_target * 1.1:
        return AdaptResponse(
            suggestion="reduce_daily",
            new_daily_amount=round(actual_daily_needed, 0),
            reasoning=(
                f"Adjusting daily target from ₹{req.daily_target:.0f} to "
                f"₹{actual_daily_needed:.0f} to stay on track."
            ),
        )

    return AdaptResponse(
        suggestion="on_track",
        reasoning=(
            f"You're on track! ₹{actual_daily_needed:.0f}/day needed, "
            f"target is ₹{req.daily_target:.0f}/day."
        ),
    )
