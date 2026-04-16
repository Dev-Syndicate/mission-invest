from fastapi import APIRouter
from ..schemas.predict import PredictRequest, PredictResponse
from ..services.prediction_service import calculate_prediction

router = APIRouter()


@router.post("/predict", response_model=PredictResponse)
async def get_prediction(request: PredictRequest) -> PredictResponse:
    """Calculate mission completion probability (rule-based MVP)."""
    return calculate_prediction(request)
