def extract_exposure_features(text):
    """
    Placeholder for LLM-based feature extraction.
    Replace with real API/model later.
    """
    features = {
        "nutrition_risk": int("malnutrition" in text.lower()),
        "stress_exposure": int("stress" in text.lower()),
        "infection_history": int("infection" in text.lower())
    }
    return features
