from ..config import settings
from ..utils.logger import logger

# Fallback templates when LLM is unavailable
_FALLBACK_TEMPLATES = [
    "You're ₹{amount_left:.0f} away from your goal. {days_left} days left. You've got this! 💪",
    "Day {streak} of your streak! Keep it alive — every rupee counts 🔥",
    "Just ₹{daily:.0f} today. That's less than a chai + samosa. Do it! ☕",
]


async def generate_message(prompt: str) -> str:
    """Generate a message using configured LLM provider.

    Falls back to template-based messages if LLM is unavailable.
    """
    try:
        if settings.llm_provider == "anthropic" and settings.anthropic_api_key:
            return await _call_anthropic(prompt)
        elif settings.llm_provider == "openai" and settings.openai_api_key:
            return await _call_openai(prompt)
        else:
            logger.warn("No LLM API key configured, using fallback template")
            return _FALLBACK_TEMPLATES[0]
    except Exception as e:
        logger.error("LLM call failed, using fallback", error=str(e))
        return _FALLBACK_TEMPLATES[0]


async def _call_anthropic(prompt: str) -> str:
    """Call Anthropic Claude API via LangChain."""
    from langchain_anthropic import ChatAnthropic

    llm = ChatAnthropic(
        model=settings.llm_model,
        api_key=settings.anthropic_api_key,
        max_tokens=200,
        temperature=0.8,
    )
    response = await llm.ainvoke(prompt)
    return response.content


async def _call_openai(prompt: str) -> str:
    """Call OpenAI API via LangChain."""
    from langchain_openai import ChatOpenAI

    llm = ChatOpenAI(
        model="gpt-4o-mini",
        api_key=settings.openai_api_key,
        max_tokens=200,
        temperature=0.8,
    )
    response = await llm.ainvoke(prompt)
    return response.content
