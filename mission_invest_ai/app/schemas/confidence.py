from pydantic import BaseModel, Field
from typing import Dict


class ConfidenceRequest(BaseModel):
    user_id: str
    streak_ratio: float = Field(..., ge=0.0, le=1.0, description="current_streak / total_days")
    checkpoint_rate: float = Field(..., ge=0.0, le=1.0, description="checkpoints_hit / checkpoints_possible")
    completion_rate: float = Field(..., ge=0.0, le=1.0, description="missions_completed / missions_created")
    recovery_rate: float = Field(..., ge=0.0, le=1.0, description="recoveries_succeeded / recoveries_used")
    consistency_bonus: bool = Field(..., description="True if no missed days in the last 7")


class ConfidenceResponse(BaseModel):
    score: int = Field(..., ge=0, le=1000)
    tier: int = Field(..., ge=1, le=5)
    label: str
    breakdown: Dict[str, float]
