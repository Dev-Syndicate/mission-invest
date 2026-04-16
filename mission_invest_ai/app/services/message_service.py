from ..schemas.message import MessageRequest, MessageResponse
from .llm_service import generate_message


async def generate_motivation(req: MessageRequest) -> MessageResponse:
    """Generate a motivational message via LLM."""

    # Determine tone
    if req.days_left <= 3:
        tone = "urgent"
    elif req.amount_left <= 0:
        tone = "celebratory"
    elif req.streak >= 7:
        tone = "encouraging"
    else:
        tone = "gentle"

    prompt = (
        f"Generate a short motivational message (max 2 sentences) for a savings app user. "
        f"Goal: '{req.goal_name}' (category: {req.category}). "
        f"Amount left: ₹{req.amount_left:.0f}. Days left: {req.days_left}. "
        f"Current streak: {req.streak} days. "
        f"{'User name: ' + req.user_name + '. ' if req.user_name else ''}"
        f"Tone: {tone}. Use emojis. Be personal and specific to their goal. "
        f"Make it relatable — compare the amount to everyday Indian spending "
        f"(Swiggy order, chai, auto ride)."
    )

    message = await generate_message(prompt)

    return MessageResponse(message=message, tone=tone)
