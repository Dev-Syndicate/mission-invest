from ..schemas.predict import PredictRequest, PredictResponse


def calculate_prediction(req: PredictRequest) -> PredictResponse:
    """Rule-based completion probability (MVP)."""
    score = (req.day_ratio * 0.5) + (req.amount_ratio * 0.4) + (req.streak_ratio * 0.1)

    # Penalize for missed days
    penalty = min(req.missed_days / max(req.total_days, 1) * 0.3, 0.3)
    probability = max(0.0, min(1.0, score - penalty))

    # Risk level
    if probability >= 0.75:
        risk_level = "low"
    elif probability >= 0.50:
        risk_level = "medium"
    elif probability >= 0.25:
        risk_level = "high"
    else:
        risk_level = "critical"

    # Factors
    factors = []
    if req.missed_days > 3:
        factors.append("high miss rate")
    if req.amount_ratio < req.day_ratio:
        factors.append("behind schedule on savings")
    if req.streak_ratio < 0.5:
        factors.append("inconsistent contributions")
    if req.day_ratio > 0.8 and req.amount_ratio < 0.6:
        factors.append("running out of time")

    return PredictResponse(
        completion_probability=round(probability, 2),
        risk_level=risk_level,
        factors=factors,
    )
