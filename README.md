💉 Vaccination Analytics Dashboard


📌 Overview

Vaccination Analytics Dashboard is an end-to-end data analytics and Business Intelligence project developed using MySQL, SQL, Exploratory Data Analysis (EDA), DAX, and Microsoft Power BI.

The project analyzes vaccination and disease-related data across countries and years to understand:

💉 Vaccination coverage
🦠 Reported disease cases
📈 Disease incidence rates
💊 Vaccine introductions
📋 Vaccination schedules

The final Power BI dashboard provides an interactive way to explore these indicators using Year and Country filters.

🎯 Objectives

Analyze vaccination coverage across countries and years
Examine reported disease cases over time
Analyze disease incidence rates
Explore historical vaccine introductions
Analyze vaccination schedule records
Perform data cleaning and exploratory analysis
Identify unusual and extreme observations
Prepare analytical datasets using SQL
Build a structured Power BI data model
Create DAX-based KPIs
Develop an interactive Power BI dashboard


🔄 Project Workflow
Raw Data
    ↓
MySQL Database
    ↓
Data Cleaning & Preparation
    ↓
Exploratory Data Analysis
    ↓
SQL Analysis & Aggregation
    ↓
Power BI Data Model
    ↓
DAX Measures
    ↓
Interactive Dashboard
    ↓
Insights & Reporting


🗂️ Dataset

The project contains the following main tables:

Table	Description
country	Country-level information
disease	Disease information
coverage	Vaccination coverage data
reported_cases	Reported disease cases
incidence	Disease incidence rates
vaccine_introduction	Historical vaccine introduction information
vaccine_schedule	Vaccination schedule information


🔍 Exploratory Data Analysis

EDA was performed to understand the structure, quality, distribution, and unusual observations within the datasets.

💉 Vaccination Coverage

Metric	Value
Original Records	399,858
Records Used for EDA	225,380
Excluded Records	174,478
Mean Coverage	78.03%
Median Coverage	88.79%

The coverage analysis identified several extreme observations, including:

Morocco — 2018 — FLU_HAJ — 32,000
Micronesia — 2020 — VAD1 — 6,604
Anguilla — 2020 — HPV_FEM — 6,100

These observations were considered during the data-quality and outlier analysis.

🦠 Disease Incidence

The incidence dataset contains 61,584 records and shows a highly skewed distribution.

Statistic	Value
Count	61,584
Mean	109.45
Median	0
75th Percentile	4.6
Maximum	69,101.3

The analysis showed many zero or low-incidence observations alongside a small number of extremely high historical values.

🗄️ SQL Analysis

MySQL was used for data preparation, aggregation, validation, and analytical analysis.

The SQL analysis included:

Vaccination coverage aggregation
Reported disease case analysis
Disease incidence analysis
Vaccine introduction analysis
Vaccination schedule analysis
Country-level comparisons
Year-level trends
Disease-level comparisons

To avoid excessive row multiplication when joining multiple analytical tables, several analyses used pre-aggregated subqueries before joining datasets.

🧠 Power BI Data Model

A dedicated DimCountryYear dimension was created to provide a consistent filtering structure across the analytical tables.

DimCountryYear
DimCountryYear
│
├── CountryYearKey
├── CountryName
└── Year
Connected Analytical Tables
                    DimCountryYear
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ▼                 ▼                 ▼
    Coverage       Reported Cases       Incidence
        │                 │                 │
        └────────────┬────┴─────────────────┘
                     │
               ┌─────┴─────┐
               ▼           ▼
        Introductions   Schedule

The Country-Year dimension enables consistent filtering across the dashboard.


🧮 DAX Measures

Average Coverage
Average Coverage =
AVERAGE(powerbi_coverage[COVERAGE])
Total Reported Cases
Total Reported Cases =
SUM(powerbi_reported_cases[CASES])
Average Incidence Rate
Average Incidence Rate =
AVERAGE(powerbi_incidence[INCIDENCE_RATE])
Total Vaccine Introductions
Total Vaccine Introductions =
SUM(powerbi_introductions[INTRODUCTIONS])
Total Schedule Records
Total Schedule Records =
SUM(powerbi_schedule[SCHEDULE_RECORDS])


📊 Dashboard

The Power BI dashboard contains five main KPI cards:

Average Coverage
Total Reported Cases
Average Incidence Rate
Total Vaccine Introductions
Total Schedule Records


📈 Visualizations

The dashboard includes:

Average Vaccination Coverage by Year
Total Reported Cases by Year
Average Vaccination Coverage by Country
Average Disease Incidence by Disease
Vaccine Introductions by Year
Vaccination Schedule Records by Year

🎛️ Interactive Features

The dashboard provides interactive filtering through:

📅 Year Slicer

Users can select a specific year or multiple years to analyze changes over time.

🌍 Country Slicer

Users can select a country to focus the dashboard analysis on a specific location.

All connected dashboard visuals update dynamically based on the selected filters.

💡 Key Findings

Vaccination coverage varies across countries and years.
The coverage dataset contains several extreme observations that require careful interpretation.
Disease incidence is highly skewed.
Many incidence observations are zero or relatively low.
A small number of historical observations show very high incidence rates.
Reported disease cases vary over time.
Vaccine introduction records provide historical context for immunization activity.
Vaccination schedule records provide additional information about immunization programs.
Combining vaccination coverage, disease cases, incidence, vaccine introductions, and schedules provides a broader analytical view of immunization data.


🛠️ Technologies Used

Technology	Purpose
MySQL	Database management and SQL analysis
SQL	Data preparation and aggregation
Power BI	Interactive dashboard development
DAX	KPI calculations and analytical measures
EDA	Data exploration and quality analysis


📁 Project Structure


vaccination-analytics-powerbi/
│
├── Vaccination_Analytics_Dashboard.pbix
│
├── README.md
│
├── SQL/
│   ├── create_database.sql
│   ├── create_tables.sql
│   └── analytical_queries.sql
│
├── EDA/
│   └── vaccination_eda/
│
├── Documentation/
│   └── project_summary.md


🚀 Project Outcome

This project demonstrates a complete data analytics workflow:

Data
 ↓
Cleaning
 ↓
EDA
 ↓
SQL Analysis
 ↓
Data Modeling
 ↓
DAX
 ↓
Power BI
 ↓
Interactive Dashboard

The final dashboard transforms vaccination datasets into an interactive analytical solution for exploring vaccination coverage, reported disease cases, incidence rates, vaccine introductions, and vaccination schedules.

📚 Skills Demonstrated

Data Cleaning
Exploratory Data Analysis
SQL
MySQL
Data Aggregation
Data Modeling
DAX
Power BI
Data Visualization
KPI Development
Interactive Dashboard Development
Business Intelligence
Analytical Storytelling


👨‍💻 Author

D.Siri Poojitha

Data Analytics | SQL | Power BI | Data Visualization