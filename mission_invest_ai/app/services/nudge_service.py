from ..schemas.nudge import NudgeRequest, NudgeResponse
from .llm_service import generate_message


async def generate_nudge(req: NudgeRequest) -> NudgeResponse:
    """Generate a nudge based on trigger and mission state."""

    # Determine action suggestion
    action = None
    suggested_params = None

    if req.completion_probability < 0.3 and req.days_left < 10:
        action = "extend_timeline"
        suggested_params = {"extra_days": 7}
    elif req.amount_left / max(req.days_left, 1) > req.target_amount / 30:
        action = "reduce_daily"
        new_daily = req.amount_left / max(req.days_left + 7, 1)
        suggested_params = {"new_daily": round(new_daily, 0)}
    elif req.missed_days <= 1:
        action = "recovery_prompt"
    else:
        action = "motivational_only"

    # Generate message via LLM
    prompt = (
        f"The user has a savings mission called '{req.mission_title}'. "
        f"They've missed {req.missed_days} days. "
        f"They have {req.days_left} days left and need to save ₹{req.amount_left:.0f} more "
        f"out of ₹{req.target_amount:.0f}. Current streak: {req.current_streak} days. "
        f"Completion probability: {req.completion_probability:.0%}. "
        f"Generate a short, energetic, emoji-forward motivational nudge (max 2 sentences). "
        f"Tone: personal, urgent but not preachy. Mention the goal name."
    )

    message = await generate_message(prompt)

    return NudgeResponse(
        message=message,
        action_suggestion=action,
        suggested_params=suggested_params,
    )
