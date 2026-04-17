from ..config import settings
from ..utils.logger import logger

# Smart fallback messages when LLM is unavailable
_NUDGE_FALLBACKS = [
    "Your {goal} mission is waiting for you! You've got {days} days left — every rupee gets you closer! 💪🔥",
    "Don't break your streak! Keep pushing towards {goal} — small steps lead to big wins! 🚀",
    "Time to fuel your {goal} mission! Just a little each day and you'll get there! ☕✨",
]

_MOTIVATION_FALLBACKS = [
    "Every rupee saved today is one step closer to {goal}! Keep going! 💰🎯",
    "You're building something amazing with {goal}! Stay consistent! 🌟",
    "Your future self will thank you for saving towards {goal} today! 🔥💪",
]


async def generate_message(prompt: str, goal: str = "your goal", days: int = 0) -> str:
    """Generate a message using Gemini Flash.

    Falls back to template-based messages if LLM is unavailable.
    """
    try:
        if settings.google_api_key:
            return await _call_gemini(prompt)
        else:
            logger.warn("No GOOGLE_API_KEY configured, using fallback template")
            return _NUDGE_FALLBACKS[0].format(goal=goal, days=days)
    except Exception as e:
        logger.error("LLM call failed, using fallback", error=str(e))
        return _NUDGE_FALLBACKS[0].format(goal=goal, days=days)


async def generate_motivation_message(prompt: str, goal: str = "your goal") -> str:
    """Generate a motivation message, with fallback."""
    try:
        if settings.google_api_key:
            return await _call_gemini(prompt)
        else:
            return _MOTIVATION_FALLBACKS[0].format(goal=goal)
    except Exception as e:
        logger.error("LLM call failed, using fallback", error=str(e))
        return _MOTIVATION_FALLBACKS[0].format(goal=goal)


async def _call_gemini(prompt: str) -> str:
    """Call Google Gemini API via LangChain."""
    from langchain_google_genai import ChatGoogleGenerativeAI

    llm = ChatGoogleGenerativeAI(
        model=settings.llm_model,
        google_api_key=settings.google_api_key,
        max_output_tokens=1024,
        temperature=0.8,
    )
    response = await llm.ainvoke(prompt)
    content = response.content
    if isinstance(content, list):
        return content[0]["text"] if content else ""
    return content
