import pandas as pd
import os


# ============================================================
# 1. LOAD RAW DATA
# ============================================================

coverage = pd.read_excel("data/raw/coverage-data.xlsx")
incidence = pd.read_excel("data/raw/incidence-rate-data.xlsx")
reported = pd.read_excel("data/raw/reported-cases-data.xlsx")
intro = pd.read_excel("data/raw/vaccine-introduction-data.xlsx")
schedule = pd.read_excel("data/raw/vaccine-schedule-data.xlsx")


# ============================================================
# 2. STANDARDIZE COLUMN NAMES
# ============================================================

datasets = {
    "coverage": coverage,
    "incidence": incidence,
    "reported": reported,
    "intro": intro,
    "schedule": schedule
}

for name, df in datasets.items():
    df.columns = (
        df.columns
        .str.strip()
        .str.upper()
        .str.replace(" ", "_")
    )


# ============================================================
# 3. CLEAN TEXT COLUMNS
# ============================================================

for name, df in datasets.items():

    text_columns = df.select_dtypes(include=["object", "string"]).columns

    for column in text_columns:
        df[column] = df[column].str.strip()


# ============================================================
# 4. CLEAN YEAR COLUMNS
# ============================================================

for name, df in datasets.items():

    df["YEAR"] = pd.to_numeric(
        df["YEAR"],
        errors="coerce"
    )

    df["YEAR"] = df["YEAR"].astype("Int64")


# ============================================================
# 5. REMOVE ROWS WITH MISSING KEY IDENTIFIERS
# ============================================================

coverage = coverage.dropna(
    subset=["CODE", "YEAR", "ANTIGEN"]
)

incidence = incidence.dropna(
    subset=["CODE", "YEAR", "DISEASE"]
)

reported = reported.dropna(
    subset=["CODE", "YEAR", "DISEASE"]
)

intro = intro.dropna(
    subset=["ISO_3_CODE", "YEAR", "DESCRIPTION"]
)

schedule = schedule.dropna(
    subset=["ISO_3_CODE", "YEAR", "VACCINECODE"]
)


# ============================================================
# 6. REMOVE DUPLICATE ROWS
# ============================================================

coverage = coverage.drop_duplicates()
incidence = incidence.drop_duplicates()
reported = reported.drop_duplicates()
intro = intro.drop_duplicates()
schedule = schedule.drop_duplicates()


# ============================================================
# 7. CREATE CLEANED FOLDER
# ============================================================

os.makedirs("data/cleaned", exist_ok=True)


# ============================================================
# 8. SAVE CLEANED DATA
# ============================================================

coverage.to_csv(
    "data/cleaned/coverage_cleaned.csv",
    index=False
)

incidence.to_csv(
    "data/cleaned/incidence_cleaned.csv",
    index=False
)

reported.to_csv(
    "data/cleaned/reported_cases_cleaned.csv",
    index=False
)

intro.to_csv(
    "data/cleaned/vaccine_introduction_cleaned.csv",
    index=False
)

schedule.to_csv(
    "data/cleaned/vaccine_schedule_cleaned.csv",
    index=False
)


# ============================================================
# 9. FINAL SUMMARY
# ============================================================

print("\n" + "=" * 60)
print("CLEANING COMPLETED")
print("=" * 60)

print("\nFinal dataset sizes:")

print("Coverage:", coverage.shape)
print("Incidence:", incidence.shape)
print("Reported Cases:", reported.shape)
print("Vaccine Introduction:", intro.shape)
print("Vaccine Schedule:", schedule.shape)

print("\nCleaned files saved to:")
print("data/cleaned/")

print("=" * 60)