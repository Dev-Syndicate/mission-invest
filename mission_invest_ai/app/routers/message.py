from fastapi import APIRouter
from ..schemas.message import MessageRequest, MessageResponse
from ..services.message_service import generate_motivation

router = APIRouter()


@router.post("/message", response_model=MessageResponse)
async def get_motivation(request: MessageRequest) -> MessageResponse:
    """Generate a personalized motivational message via LLM."""
    return await generate_motivation(request)
