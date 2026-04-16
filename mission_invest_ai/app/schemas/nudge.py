from pydantic import BaseModel
from typing import Literal, Optional, Dict, Any


class NudgeRequest(BaseModel):
    user_id: str
    mission_id: str
    mission_title: str
    trigger: Literal["missed_day", "low_probability", "manual_request"]
    current_streak: int
    missed_days: int
    days_left: int
    amount_left: float
    target_amount: float
    completion_probability: float


class NudgeResponse(BaseModel):
    message: str
    action_suggestion: Optional[
        Literal[
            "extend_timeline",
            "reduce_daily",
            "split_mission",
            "motivational_only",
            "recovery_prompt",
        ]
    ] = None
    suggested_params: Optional[Dict[str, Any]] = None
