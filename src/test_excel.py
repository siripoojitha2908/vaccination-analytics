import pandas as pd

df = pd.read_excel(
    "data/raw/coverage-data.xlsx",
    sheet_name=0,
    nrows=5
)

print(df.head())