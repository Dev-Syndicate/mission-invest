from pydantic import BaseModel
from typing import Optional


class StorySuggestRequest(BaseModel):
    category: str
    goal_name: str


class StorySuggestResponse(BaseModel):
    headline: str
    emoji: str
    is_custom: bool = False
