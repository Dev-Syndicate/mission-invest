from ..schemas.story import StorySuggestRequest, StorySuggestResponse
from .llm_service import generate_message

# Auto-suggested headlines per category (PRD 5.14)
_CATEGORY_SUGGESTIONS = {
    "trip": {
        "headline": "Travel is the only thing you buy that makes you richer.",
        "emoji": "✈️",
    },
    "gadget": {
        "headline": "The right tool unlocks your best work.",
        "emoji": "💻",
    },
    "vehicle": {
        "headline": "Your own ride. Your own rules.",
        "emoji": "🏍️",
    },
    "emergency": {
        "headline": "Peace of mind is worth every rupee.",
        "emoji": "💰",
    },
    "course": {
        "headline": "Invest in yourself — the returns are limitless.",
        "emoji": "🎓",
    },
    "gift": {
        "headline": "Make someone's day unforgettable.",
        "emoji": "🎁",
    },
}


async def suggest_story(req: StorySuggestRequest) -> StorySuggestResponse:
    """Suggest a story headline and emoji for a mission.

    Uses hardcoded defaults for known categories (PRD 5.14).
    Falls back to LLM generation for custom/unknown categories.
    """
    category_lower = req.category.lower()

    if category_lower in _CATEGORY_SUGGESTIONS:
        suggestion = _CATEGORY_SUGGESTIONS[category_lower]
        return StorySuggestResponse(
            headline=suggestion["headline"],
            emoji=suggestion["emoji"],
            is_custom=False,
        )

    # For custom categories, use LLM to generate a suggestion
    prompt = (
        f"Generate a short, inspiring one-line headline (max 15 words) for a savings goal. "
        f"Category: '{req.category}'. Goal name: '{req.goal_name}'. "
        f"Also suggest a single emoji that best represents this goal. "
        f"Format: HEADLINE | EMOJI (just the emoji character, no colons). "
        f"Example: 'The right tool unlocks your best work. | 💻'"
    )

    try:
        raw = await generate_message(prompt)
        if "|" in raw:
            parts = raw.split("|", 1)
            headline = parts[0].strip().strip('"').strip("'")
            emoji = parts[1].strip()
            # Validate emoji is a single character/sequence (basic check)
            if not emoji or len(emoji) > 4:
                emoji = "🎯"
        else:
            headline = raw.strip().strip('"').strip("'")
            emoji = "🎯"
    except Exception:
        headline = f"Every step toward '{req.goal_name}' is a step worth taking."
        emoji = "🎯"

    return StorySuggestResponse(
        headline=headline,
        emoji=emoji,
        is_custom=True,
    )
