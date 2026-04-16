from fastapi import APIRouter
from ..schemas.story import StorySuggestRequest, StorySuggestResponse
from ..services.story_service import suggest_story

router = APIRouter()


@router.post("/story-suggest", response_model=StorySuggestResponse)
async def get_story_suggestion(request: StorySuggestRequest) -> StorySuggestResponse:
    """Suggest a story headline and emoji for a mission goal."""
    return await suggest_story(request)
