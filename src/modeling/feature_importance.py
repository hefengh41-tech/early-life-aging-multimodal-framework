import pandas as pd

def get_feature_importance(model, feature_names):
    importance = model.feature_importances_
    df = pd.DataFrame({
        "feature": feature_names,
        "importance": importance
    }).sort_values(by="importance", ascending=False)

    print(df.head(10))
    return df
