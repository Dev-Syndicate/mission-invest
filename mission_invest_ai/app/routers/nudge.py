from fastapi import APIRouter
from ..schemas.nudge import NudgeRequest, NudgeResponse
from ..services.nudge_service import generate_nudge

router = APIRouter()


@router.post("/nudge", response_model=NudgeResponse)
async def get_nudge(request: NudgeRequest) -> NudgeResponse:
    """Generate an AI-powered nudge for a struggling mission."""
    return await generate_nudge(request)
