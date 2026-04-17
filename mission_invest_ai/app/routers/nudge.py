from fastapi import APIRouter
from ..schemas.nudge import NudgeRequest, NudgeResponse
from ..services.nudge_service import generate_nudge

router = APIRouter()


@router.post("/nudge", response_model=NudgeResponse, response_model_by_alias=True)
async def get_nudge(request: NudgeRequest) -> NudgeResponse:
    """Generate an AI-powered nudge for a struggling mission."""
    return await generate_nudge(request)
