import pandas as pd
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL
from getpass import getpass


# ============================================================
# 1. MYSQL CONNECTION
# ============================================================

print("=" * 60)
print("VACCINATION ANALYTICS - DATABASE LOADER")
print("=" * 60)

password = getpass("Enter your MySQL root password: ")

connection_url = URL.create(
    drivername="mysql+pymysql",
    username="root",
    password=password,
    host="localhost",
    port=3306,
    database="vaccination_analytics"
)

engine = create_engine(connection_url)

print("\nConnected to MySQL successfully.")


# ============================================================
# 2. LOAD CLEANED CSV FILES
# ============================================================

coverage = pd.read_csv(
    "data/cleaned/coverage_cleaned.csv"
)

incidence = pd.read_csv(
    "data/cleaned/incidence_cleaned.csv"
)

reported = pd.read_csv(
    "data/cleaned/reported_cases_cleaned.csv"
)

intro = pd.read_csv(
    "data/cleaned/vaccine_introduction_cleaned.csv"
)

schedule = pd.read_csv(
    "data/cleaned/vaccine_schedule_cleaned.csv"
)

print("\nCleaned files loaded.")


# ============================================================
# 3. CREATE COUNTRY DIMENSION
# ============================================================

country_data = []

# Coverage
country_data.append(
    coverage[
        ["CODE", "NAME"]
    ].rename(
        columns={
            "CODE": "iso_code",
            "NAME": "country_name"
        }
    )
)

# Vaccine Introduction
country_data.append(
    intro[
        ["ISO_3_CODE", "COUNTRYNAME", "WHO_REGION"]
    ].rename(
        columns={
            "ISO_3_CODE": "iso_code",
            "COUNTRYNAME": "country_name",
            "WHO_REGION": "who_region"
        }
    )
)

# Vaccine Schedule
country_data.append(
    schedule[
        ["ISO_3_CODE", "COUNTRYNAME", "WHO_REGION"]
    ].rename(
        columns={
            "ISO_3_CODE": "iso_code",
            "COUNTRYNAME": "country_name",
            "WHO_REGION": "who_region"
        }
    )
)

countries = pd.concat(
    country_data,
    ignore_index=True
)


# ============================================================
# 4. CLEAN COUNTRY DIMENSION
# ============================================================

countries["iso_code"] = countries["iso_code"].astype(str).str.strip()

countries["country_name"] = (
    countries["country_name"]
    .astype("string")
    .str.strip()
)

countries["who_region"] = (
    countries["who_region"]
    .astype("string")
    .str.strip()
)

# Remove invalid ISO codes
countries = countries[
    countries["iso_code"].notna()
    & (countries["iso_code"] != "")
    & (countries["iso_code"] != "nan")
]

# Sort so non-null names/regions appear first
countries = countries.sort_values(
    ["iso_code", "country_name"],
    na_position="last"
)

# Keep one row per country
countries = countries.drop_duplicates(
    subset=["iso_code"],
    keep="first"
)

# If country name is missing, use ISO code
countries["country_name"] = countries["country_name"].fillna(
    countries["iso_code"]
)

countries = countries[
    ["iso_code", "country_name", "who_region"]
]

# ============================================================
# 5. CREATE DISEASE DIMENSION
# ============================================================

disease_data = pd.concat(
    [
        incidence[
            ["DISEASE", "DISEASE_DESCRIPTION"]
        ],
        reported[
            ["DISEASE", "DISEASE_DESCRIPTION"]
        ]
    ],
    ignore_index=True
)

disease_data = disease_data.rename(
    columns={
        "DISEASE": "disease_code",
        "DISEASE_DESCRIPTION": "disease_description"
    }
)

disease_data["disease_code"] = (
    disease_data["disease_code"]
    .astype(str)
    .str.strip()
)

disease_data["disease_description"] = (
    disease_data["disease_description"]
    .astype("string")
    .str.strip()
)

disease_data = disease_data[
    disease_data["disease_code"].notna()
    & (disease_data["disease_code"] != "")
    & (disease_data["disease_code"] != "nan")
]

disease_data = disease_data.sort_values(
    ["disease_code", "disease_description"],
    na_position="last"
)

disease_data = disease_data.drop_duplicates(
    subset=["disease_code"],
    keep="first"
)

disease_data = disease_data[
    ["disease_code", "disease_description"]
]


# ============================================================
# 6. CLEAR EXISTING DATA
# ============================================================

print("\nClearing existing table data...")

with engine.begin() as connection:

    connection.execute(
        text("DELETE FROM vaccine_schedule")
    )

    connection.execute(
        text("DELETE FROM vaccine_introduction")
    )

    connection.execute(
        text("DELETE FROM reported_cases")
    )

    connection.execute(
        text("DELETE FROM incidence")
    )

    connection.execute(
        text("DELETE FROM coverage")
    )

    connection.execute(
        text("DELETE FROM disease")
    )

    connection.execute(
        text("DELETE FROM country")
    )

print("Existing data cleared.")


# ============================================================
# 7. INSERT COUNTRY AND DISEASE DIMENSIONS
# ============================================================

print("\nInserting countries...")

countries.to_sql(
    "country",
    con=engine,
    if_exists="append",
    index=False,
    chunksize=1000
)

print("Countries inserted:", len(countries))


print("\nInserting diseases...")

disease_data.to_sql(
    "disease",
    con=engine,
    if_exists="append",
    index=False,
    chunksize=1000
)

print("Diseases inserted:", len(disease_data))


# ============================================================
# 8. READ GENERATED IDS
# ============================================================

country_lookup = pd.read_sql(
    "SELECT country_id, iso_code FROM country",
    engine
)

disease_lookup = pd.read_sql(
    "SELECT disease_id, disease_code FROM disease",
    engine
)


# ============================================================
# 9. PREPARE COVERAGE
# ============================================================

coverage = coverage.merge(
    country_lookup,
    left_on="CODE",
    right_on="iso_code",
    how="left"
)

coverage = coverage[
    [
        "country_id",
        "YEAR",
        "ANTIGEN",
        "ANTIGEN_DESCRIPTION",
        "COVERAGE_CATEGORY",
        "COVERAGE_CATEGORY_DESCRIPTION",
        "TARGET_NUMBER",
        "DOSES",
        "COVERAGE"
    ]
]

coverage = coverage.rename(
    columns={
        "country_id": "country_id",
        "YEAR": "year",
        "ANTIGEN": "antigen",
        "ANTIGEN_DESCRIPTION": "antigen_description",
        "COVERAGE_CATEGORY": "coverage_category",
        "COVERAGE_CATEGORY_DESCRIPTION": "coverage_category_description",
        "TARGET_NUMBER": "target_number",
        "DOSES": "doses",
        "COVERAGE": "coverage"
    }
)


# ============================================================
# 10. PREPARE INCIDENCE
# ============================================================

incidence = incidence.merge(
    country_lookup,
    left_on="CODE",
    right_on="iso_code",
    how="left"
)

incidence = incidence.merge(
    disease_lookup,
    left_on="DISEASE",
    right_on="disease_code",
    how="left"
)

incidence = incidence[
    [
        "country_id",
        "disease_id",
        "YEAR",
        "DENOMINATOR",
        "INCIDENCE_RATE"
    ]
]

incidence = incidence.rename(
    columns={
        "YEAR": "year",
        "DENOMINATOR": "denominator",
        "INCIDENCE_RATE": "incidence_rate"
    }
)


# ============================================================
# 11. PREPARE REPORTED CASES
# ============================================================

reported = reported.merge(
    country_lookup,
    left_on="CODE",
    right_on="iso_code",
    how="left"
)

reported = reported.merge(
    disease_lookup,
    left_on="DISEASE",
    right_on="disease_code",
    how="left"
)

reported = reported[
    [
        "country_id",
        "disease_id",
        "YEAR",
        "CASES"
    ]
]

reported = reported.rename(
    columns={
        "YEAR": "year",
        "CASES": "cases"
    }
)


# ============================================================
# 12. PREPARE VACCINE INTRODUCTION
# ============================================================

intro = intro.merge(
    country_lookup,
    left_on="ISO_3_CODE",
    right_on="iso_code",
    how="left"
)

intro = intro[
    [
        "country_id",
        "YEAR",
        "DESCRIPTION",
        "INTRO"
    ]
]

intro = intro.rename(
    columns={
        "YEAR": "year",
        "DESCRIPTION": "vaccine_description",
        "INTRO": "intro"
    }
)


# ============================================================
# 13. PREPARE VACCINE SCHEDULE
# ============================================================

schedule = schedule.merge(
    country_lookup,
    left_on="ISO_3_CODE",
    right_on="iso_code",
    how="left"
)

schedule = schedule[
    [
        "country_id",
        "YEAR",
        "VACCINECODE",
        "VACCINE_DESCRIPTION",
        "SCHEDULEROUNDS",
        "TARGETPOP",
        "TARGETPOP_DESCRIPTION",
        "GEOAREA",
        "AGEADMINISTERED",
        "SOURCECOMMENT"
    ]
]

schedule = schedule.rename(
    columns={
        "YEAR": "year",
        "VACCINECODE": "vaccine_code",
        "VACCINE_DESCRIPTION": "vaccine_description",
        "SCHEDULEROUNDS": "schedule_rounds",
        "TARGETPOP": "target_pop",
        "TARGETPOP_DESCRIPTION": "target_pop_description",
        "GEOAREA": "geoarea",
        "AGEADMINISTERED": "age_administered",
        "SOURCECOMMENT": "source_comment"
    }
)


# ============================================================
# 14. INSERT FACT TABLES
# ============================================================

print("\nInserting Coverage data...")

coverage.to_sql(
    "coverage",
    con=engine,
    if_exists="append",
    index=False,
    chunksize=5000
)

print("Coverage inserted:", len(coverage))


print("\nInserting Incidence data...")

incidence.to_sql(
    "incidence",
    con=engine,
    if_exists="append",
    index=False,
    chunksize=5000
)

print("Incidence inserted:", len(incidence))


print("\nInserting Reported Cases data...")

reported.to_sql(
    "reported_cases",
    con=engine,
    if_exists="append",
    index=False,
    chunksize=5000
)

print("Reported Cases inserted:", len(reported))


print("\nInserting Vaccine Introduction data...")

intro.to_sql(
    "vaccine_introduction",
    con=engine,
    if_exists="append",
    index=False,
    chunksize=5000
)

print("Vaccine Introduction inserted:", len(intro))


print("\nInserting Vaccine Schedule data...")

schedule.to_sql(
    "vaccine_schedule",
    con=engine,
    if_exists="append",
    index=False,
    chunksize=5000
)

print("Vaccine Schedule inserted:", len(schedule))


# ============================================================
# 15. VERIFY DATABASE
# ============================================================

print("\n" + "=" * 60)
print("DATABASE LOAD COMPLETED")
print("=" * 60)

with engine.connect() as connection:

    tables = [
        "country",
        "disease",
        "coverage",
        "incidence",
        "reported_cases",
        "vaccine_introduction",
        "vaccine_schedule"
    ]

    print("\nDatabase row counts:")

    for table in tables:

        result = connection.execute(
            text(f"SELECT COUNT(*) FROM {table}")
        )

        count = result.scalar()

        print(f"{table}: {count:,}")

print("\nAll data loaded successfully.")
print("=" * 60)