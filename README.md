# 💉 Vaccination Analytics Dashboard

<p align="center">
  <img src="https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black" />
  <img src="https://img.shields.io/badge/MySQL-Database-4479A1?style=for-the-badge&logo=mysql&logoColor=white" />
  <img src="https://img.shields.io/badge/SQL-Analysis-336791?style=for-the-badge&logo=postgresql&logoColor=white" />
  <img src="https://img.shields.io/badge/DAX-Analytics-8A2BE2?style=for-the-badge" />
  <img src="https://img.shields.io/badge/EDA-Data%20Analysis-20B2AA?style=for-the-badge" />
</p>

<p align="center">
  <b>🌍 An interactive data analytics and business intelligence project for exploring global vaccination coverage, disease burden, and immunization trends.</b>
</p>

---

## 📌 Project Overview

**Vaccination Analytics Dashboard** is an end-to-end data analytics and Business Intelligence project developed using **MySQL, SQL, Exploratory Data Analysis (EDA), and Microsoft Power BI**.

The project analyzes vaccination-related data across **countries and years**, focusing on:

- 💉 Vaccination coverage
- 🦠 Reported disease cases
- 📈 Disease incidence rates
- 💊 Vaccine introductions
- 📋 Vaccination schedules

The final result is an interactive **Power BI dashboard** that allows users to explore vaccination trends and disease-related indicators using dynamic filters.

---

## 🎯 Project Objective

The main objective of this project is to transform raw vaccination datasets into meaningful analytical insights through a complete data analytics workflow.

### Key Goals

- Analyze vaccination coverage across countries and years
- Understand reported disease cases over time
- Examine disease incidence rates
- Analyze historical vaccine introductions
- Explore vaccination schedule records
- Identify unusual and extreme observations during EDA
- Build an interactive Power BI dashboard
- Enable dynamic analysis using **Year** and **Country** filters

---

## 🏗️ Project Workflow

```text
Raw Data
   │
   ▼
MySQL Database
   │
   ▼
Data Cleaning & Preparation
   │
   ▼
Exploratory Data Analysis
   │
   ▼
SQL Analysis & Aggregation
   │
   ▼
Power BI Data Model
   │
   ▼
DAX Measures
   │
   ▼
Interactive Dashboard
   │
   ▼
Insights & Reporting
````

---

## 🗂️ Dataset Structure

The project uses multiple analytical tables:

| Table                     | Description                                 |
| ------------------------- | ------------------------------------------- |
| 🌍 `country`              | Country-level information                   |
| 🦠 `disease`              | Disease information                         |
| 💉 `coverage`             | Vaccination coverage data                   |
| 📊 `reported_cases`       | Reported disease cases                      |
| 📈 `incidence`            | Disease incidence rates                     |
| 💊 `vaccine_introduction` | Historical vaccine introduction information |
| 📋 `vaccine_schedule`     | Vaccination schedule information            |

The dashboard analysis covers multiple countries and years, allowing both geographical and time-based analysis.

---

# 🔍 Exploratory Data Analysis

EDA was performed before building the Power BI dashboard to understand the structure, quality, distribution, and potential anomalies in the data.

### 💉 Vaccination Coverage

Key observations from the coverage analysis:

* Original coverage records: **399,858**
* Records used for EDA: **225,380**
* Excluded records: **174,478**
* Median coverage: **88.79%**
* Mean coverage: **78.03%**

The analysis also identified extreme observations, including coverage values significantly above the expected percentage range.

Examples included:

* Morocco — 2018 — FLU_HAJ — **32,000**
* Micronesia — 2020 — VAD1 — **6,604**
* Anguilla — 2020 — HPV_FEM — **6,100**

These observations were treated as important data-quality considerations rather than being silently ignored.

---

### 🦠 Disease Incidence

Incidence analysis showed a highly skewed distribution.

| Statistic       |    Value |
| --------------- | -------: |
| Records         |   61,584 |
| Mean            |   109.45 |
| Median          |        0 |
| 75th Percentile |      4.6 |
| Maximum         | 69,101.3 |

Some historical observations showed extremely high incidence values, demonstrating the importance of examining distributions and outliers before visualization.

---

# 🗄️ SQL Analysis

MySQL was used for data preparation, aggregation, validation, and analytical queries.

The SQL workflow included:

* Aggregating vaccination coverage
* Calculating reported disease cases
* Analyzing disease incidence
* Counting vaccine introductions
* Analyzing vaccination schedule records
* Country-level comparisons
* Year-level trend analysis
* Disease-level analysis

### ⚡ Query Optimization

Some initial queries produced large intermediate datasets because of joins between multiple fact tables.

To improve performance, the analysis was redesigned using:

```text
Pre-aggregation
      ↓
Grouped subqueries
      ↓
Controlled joins
      ↓
Final analytical result
```

This reduced row multiplication and improved query execution.

---

# 🧠 Power BI Data Model

A dedicated **Country-Year dimension** was created to provide a consistent filtering structure across the analytical datasets.

### Dimension

```text
DimCountryYear
├── CountryYearKey
├── CountryName
└── Year
```

### Connected Tables

```text
                 ┌──────────────────────┐
                 │    DimCountryYear    │
                 │                      │
                 │ CountryYearKey       │
                 │ CountryName          │
                 │ Year                 │
                 └──────────┬───────────┘
                            │
        ┌───────────────────┼────────────────────┐
        │                   │                    │
        ▼                   ▼                    ▼
   Coverage           Reported Cases        Incidence
        │                   │                    │
        └───────────────┬───┴────────────────────┘
                        │
                 ┌──────┴──────┐
                 ▼             ▼
             Introductions   Schedule
```

This structure supports consistent filtering across the dashboard.

---

# 📊 DAX Measures

The dashboard uses DAX measures to calculate the main KPIs.

### Average Coverage

```DAX
Average Coverage =
AVERAGE(powerbi_coverage[COVERAGE])
```

### Total Reported Cases

```DAX
Total Reported Cases =
SUM(powerbi_reported_cases[CASES])
```

### Average Incidence Rate

```DAX
Average Incidence Rate =
AVERAGE(powerbi_incidence[INCIDENCE_RATE])
```

### Total Vaccine Introductions

```DAX
Total Vaccine Introductions =
SUM(powerbi_introductions[INTRODUCTIONS])
```

### Total Schedule Records

```DAX
Total Schedule Records =
SUM(powerbi_schedule[SCHEDULE_RECORDS])
```

---

# 📈 Dashboard Features

The final Power BI dashboard contains several interactive visualizations.

### 🔢 KPI Cards

The dashboard displays:

* **Average Coverage**
* **Total Reported Cases**
* **Average Incidence Rate**
* **Total Vaccine Introductions**
* **Total Schedule Records**

---

### 📉 Vaccination Coverage Trend

A yearly line chart shows how average vaccination coverage changes over time.

---

### 🦠 Reported Cases Trend

A time-series visualization shows total reported disease cases by year.

---

### 🌍 Country Coverage Map

A geographical visualization represents vaccination coverage across countries.

This allows users to explore geographical differences in vaccination coverage.

---

### 📊 Disease Incidence Analysis

A column chart compares average incidence rates across diseases.

---

### 💊 Vaccine Introduction Trends

A yearly visualization tracks vaccine introduction records over time.

---

### 📋 Vaccination Schedule Trends

A time-series visualization shows vaccination schedule records by year.

---

# 🎛️ Interactive Filters

The dashboard includes dynamic slicers for:

### 📅 Year

Allows users to analyze a specific year or range of years.

### 🌍 Country

Allows users to focus the dashboard on an individual country.

When a slicer is changed, the dashboard visuals update dynamically.

---

# 💡 Key Insights

The analysis provides several useful observations:

* Vaccination coverage varies considerably across countries and years.
* The coverage data contains unusual extreme values that require careful interpretation.
* Disease incidence is highly skewed, with many observations at or near zero and a small number of very high values.
* Reported disease cases vary over time and across countries.
* Vaccine introduction records provide historical context for immunization programs.
* Vaccination schedule records provide an additional perspective on immunization activity.
* Combining vaccination and disease indicators provides a broader view of immunization patterns.

> **Note:** The dashboard is an analytical tool. Differences in reporting practices, data availability, historical coverage estimates, and unusual observations should be considered when interpreting results.

---

# 🛠️ Tools & Technologies

| Technology      | Purpose                               |
| --------------- | ------------------------------------- |
| 🐬 **MySQL**    | Database management and SQL analysis  |
| 📊 **Power BI** | Dashboard and data visualization      |
| 🧮 **DAX**      | Analytical measures and KPIs          |
| 🔎 **EDA**      | Data quality and statistical analysis |
| 🗃️ **SQL**     | Data aggregation and transformation   |

---


# 📚 Skills Demonstrated

This project demonstrates practical experience in:

* ✅ Data Cleaning
* ✅ Data Exploration
* ✅ Exploratory Data Analysis
* ✅ SQL Querying
* ✅ MySQL
* ✅ Data Aggregation
* ✅ Data Modeling
* ✅ DAX
* ✅ Power BI
* ✅ Data Visualization
* ✅ KPI Development
* ✅ Interactive Dashboard Design
* ✅ Business Intelligence
* ✅ Analytical Storytelling

---

# 🎓 Project Outcome

This project demonstrates a complete analytics workflow:

> **Raw Data → SQL → EDA → Data Modeling → DAX → Power BI → Interactive Insights**

The final dashboard transforms complex vaccination datasets into an interactive analytical interface that makes country-level and year-level exploration easier.

---

# 👨‍💻 Author

**D.Siri Poojitha**

📌 Data Analytics | SQL | Power BI | Data Visualization

---

## ⭐ If you found this project useful

Consider giving the repository a ⭐ and exploring the project!

---

<p align="center">
  <b>💉 Vaccination Analytics Dashboard</b><br>
  Turning vaccination data into meaningful insights.
</p>
```

