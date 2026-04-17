from fastapi import APIRouter
from ..schemas.adapt import AdaptRequest, AdaptResponse
from ..services.adapt_service import generate_adaptation

router = APIRouter()


@router.post("/adapt", response_model=AdaptResponse, response_model_by_alias=True)
async def get_adaptation(request: AdaptRequest) -> AdaptResponse:
    """Suggest mission adaptation based on current progress."""
    return generate_adaptation(request)
