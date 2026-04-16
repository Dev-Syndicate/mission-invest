from fastapi import APIRouter
from ..schemas.confidence import ConfidenceRequest, ConfidenceResponse
from ..services.confidence_service import calculate_confidence

router = APIRouter()


@router.post("/confidence", response_model=ConfidenceResponse)
async def get_confidence(request: ConfidenceRequest) -> ConfidenceResponse:
    """Calculate the user's Financial Confidence Score (0–1000)."""
    return calculate_confidence(request)
