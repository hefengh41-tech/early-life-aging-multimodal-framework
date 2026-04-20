import pandas as pd

def classify():
    df = pd.read_csv("outputs/tables/chronic_disease_filtered.csv")

    category_map = {
        'inflammation': 'Inflammation / Immune',
        'autoimmune': 'Inflammation / Immune',
        'arthritis': 'Inflammation / Immune',
        'rheumat': 'Inflammation / Immune',
        'cardio': 'Cardiovascular',
        'atherosclerosis': 'Cardiovascular',
        'hypertension': 'Cardiovascular',
        'heart': 'Cardiovascular',
        'obesity': 'Metabolic / Endocrine',
        'diabetes': 'Metabolic / Endocrine',
        'alzheimer': 'Neurodegenerative',
        'neurodegeneration': 'Neurodegenerative',
        'asthma': 'Pulmonary',
        'copd': 'Pulmonary',
        'lung': 'Pulmonary',
        'cancer': 'Cancer / Neoplastic',
        'tumor': 'Cancer / Neoplastic',
        'malignan': 'Cancer / Neoplastic'
    }

    def assign_category(name):
        name = str(name).lower()
        for key, cat in category_map.items():
            if key in name:
                return cat
        return 'Other / Systemic'

    df["Category"] = df["DiseaseName"].apply(assign_category)

    df.to_csv("outputs/tables/chronic_disease_by_category.csv", index=False)

    print("Categories assigned")

if __name__ == "__main__":
    classify()
