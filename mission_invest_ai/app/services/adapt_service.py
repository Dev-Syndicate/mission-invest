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
    progress_ratio = req.current_saved / req.target_amount if req.target_amount > 0 else 0

    # Early stage: saved very little relative to goal — suggest a comfortable plan
    if progress_ratio < 0.20 and req.days_left <= 30:
        comfortable_daily = round(remaining / 45, 0)
        new_end = (datetime.now() + timedelta(days=45)).date().isoformat()
        return AdaptResponse(
            suggestion="extend_timeline",
            new_daily_amount=comfortable_daily,
            new_end_date=new_end,
            reasoning=(
                f"You've saved {progress_ratio:.0%} so far with {req.days_left} days left. "
                f"Extending to 45 days at ₹{comfortable_daily:.0f}/day makes this "
                f"more achievable without pressure."
            ),
        )

    # If actual daily needed is more than 1.3x the original target
    if actual_daily_needed > req.daily_target * 1.3:
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

    # If actual daily is noticeably higher (5%+ gap), suggest adjusting
    if actual_daily_needed > req.daily_target * 1.05:
        return AdaptResponse(
            suggestion="reduce_daily",
            new_daily_amount=round(actual_daily_needed, 0),
            reasoning=(
                f"Adjusting daily target from ₹{req.daily_target:.0f} to "
                f"₹{actual_daily_needed:.0f} to stay on track with your current pace."
            ),
        )

    return AdaptResponse(
        suggestion="on_track",
        reasoning=(
            f"You're on track! ₹{actual_daily_needed:.0f}/day needed, "
            f"target is ₹{req.daily_target:.0f}/day."
        ),
    )
