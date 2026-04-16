from ..schemas.confidence import ConfidenceRequest, ConfidenceResponse

# Tier definitions per PRD 5.12
_TIERS = [
    (200, 1, "Beginner Saver"),
    (400, 2, "Building Habits"),
    (600, 3, "Consistent Saver"),
    (800, 4, "Mission Pro"),
    (1001, 5, "Financial Athlete"),
]


def calculate_confidence(req: ConfidenceRequest) -> ConfidenceResponse:
    """Calculate Financial Confidence Score (0–1000) per PRD formula.

    score = (streak_ratio * 300)
          + (checkpoint_rate * 250)
          + (completion_rate * 250)
          + (recovery_rate * 100)
          + (consistency_bonus * 100)
    """
    streak_component = req.streak_ratio * 300
    checkpoint_component = req.checkpoint_rate * 250
    completion_component = req.completion_rate * 250
    recovery_component = req.recovery_rate * 100
    consistency_component = 100.0 if req.consistency_bonus else 0.0

    raw_score = (
        streak_component
        + checkpoint_component
        + completion_component
        + recovery_component
        + consistency_component
    )

    # Clamp to 0–1000
    score = max(0, min(1000, int(round(raw_score))))

    # Determine tier
    tier = 1
    label = "Beginner Saver"
    for threshold, tier_num, tier_label in _TIERS:
        if score < threshold:
            tier = tier_num
            label = tier_label
            break

    return ConfidenceResponse(
        score=score,
        tier=tier,
        label=label,
        breakdown={
            "streak": round(streak_component, 1),
            "checkpoints": round(checkpoint_component, 1),
            "completions": round(completion_component, 1),
            "recovery": round(recovery_component, 1),
            "consistency": round(consistency_component, 1),
        },
    )
