from pydantic import BaseModel
from typing import Literal, Optional


class MessageRequest(BaseModel):
    goal_name: str
    amount_left: float
    days_left: int
    streak: int
    category: str
    user_name: Optional[str] = None


class MessageResponse(BaseModel):
    message: str
    tone: Literal["encouraging", "urgent", "celebratory", "gentle"]
