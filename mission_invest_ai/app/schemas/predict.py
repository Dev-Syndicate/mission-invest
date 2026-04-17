from pydantic import BaseModel, ConfigDict
from pydantic.alias_generators import to_camel
from typing import Literal, List


class PredictRequest(BaseModel):
    mission_id: str
    streak_ratio: float
    amount_ratio: float
    day_ratio: float
    missed_days: int
    total_days: int


class PredictResponse(BaseModel):
    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)

    completion_probability: float
    risk_level: Literal["low", "medium", "high", "critical"]
    factors: List[str]
