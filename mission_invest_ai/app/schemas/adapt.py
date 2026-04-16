from pydantic import BaseModel
from typing import Literal, Optional


class AdaptRequest(BaseModel):
    mission_id: str
    mission_title: str
    current_saved: float
    days_left: int
    target_amount: float
    daily_target: float
    current_streak: int
    ahead_flag: bool = False


class AdaptResponse(BaseModel):
    suggestion: Literal["reduce_daily", "extend_timeline", "split_mission", "on_track", "ahead_of_schedule"]
    new_daily_amount: Optional[float] = None
    new_end_date: Optional[str] = None
    early_completion_date: Optional[str] = None
    reasoning: str
