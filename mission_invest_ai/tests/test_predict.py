from app.schemas.predict import PredictRequest
from app.services.prediction_service import calculate_prediction


def test_high_probability():
    req = PredictRequest(
        mission_id="test1",
        streak_ratio=0.9,
        amount_ratio=0.8,
        day_ratio=0.7,
        missed_days=1,
        total_days=30,
    )
    result = calculate_prediction(req)
    assert result.risk_level == "low"
    assert result.completion_probability >= 0.7


def test_low_probability():
    req = PredictRequest(
        mission_id="test2",
        streak_ratio=0.1,
        amount_ratio=0.2,
        day_ratio=0.8,
        missed_days=15,
        total_days=30,
    )
    result = calculate_prediction(req)
    assert result.risk_level in ("high", "critical")
    assert result.completion_probability < 0.5


def test_factors_behind_schedule():
    req = PredictRequest(
        mission_id="test3",
        streak_ratio=0.3,
        amount_ratio=0.3,
        day_ratio=0.7,
        missed_days=5,
        total_days=30,
    )
    result = calculate_prediction(req)
    assert "behind schedule on savings" in result.factors
