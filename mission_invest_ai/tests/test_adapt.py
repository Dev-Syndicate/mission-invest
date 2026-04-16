from app.schemas.adapt import AdaptRequest
from app.services.adapt_service import generate_adaptation


def test_on_track():
    req = AdaptRequest(
        mission_id="test1",
        mission_title="Goa Trip",
        current_saved=5000,
        days_left=25,
        target_amount=10000,
        daily_target=200,
        current_streak=10,
    )
    result = generate_adaptation(req)
    assert result.suggestion == "on_track"


def test_extend_timeline():
    req = AdaptRequest(
        mission_id="test2",
        mission_title="Laptop",
        current_saved=2000,
        days_left=5,
        target_amount=50000,
        daily_target=1000,
        current_streak=2,
    )
    result = generate_adaptation(req)
    assert result.suggestion == "extend_timeline"
    assert result.new_end_date is not None


def test_fully_funded():
    req = AdaptRequest(
        mission_id="test3",
        mission_title="Gift",
        current_saved=5000,
        days_left=10,
        target_amount=5000,
        daily_target=500,
        current_streak=5,
    )
    result = generate_adaptation(req)
    assert result.suggestion == "on_track"
