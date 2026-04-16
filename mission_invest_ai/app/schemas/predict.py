from pydantic import BaseModel
from typing import Literal, List


class PredictRequest(BaseModel):
    mission_id: str
    streak_ratio: float
    amount_ratio: float
    day_ratio: float
    missed_days: int
    total_days: int


class PredictResponse(BaseModel):
    completion_probability: float
    risk_level: Literal["low", "medium", "high", "critical"]
    factors: List[str]
