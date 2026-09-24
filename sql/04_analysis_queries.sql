USE vaccination_analytics;

-- ============================================================
-- VACCINATION ANALYTICS - SQL ANALYSIS
-- ============================================================


-- ============================================================
-- EASY QUESTIONS
-- ============================================================


-- Q1. How many countries are present in the database?
SELECT COUNT(*) AS total_countries
FROM country;


-- Q2. How many diseases are present in the database?
SELECT COUNT(*) AS total_diseases
FROM disease;


-- Q3. How many vaccination coverage records are present?
SELECT COUNT(*) AS total_coverage_records
FROM coverage;


-- Q4. How many reported disease case records are present?
SELECT COUNT(*) AS total_reported_case_records
FROM reported_cases;


-- Q5. What are the diseases available in the database?
-- Q5. What are the diseases available in the database?
SELECT
    disease_id,
    disease_code,
    disease_description
FROM disease
ORDER BY disease_description;


-- Q6. What countries are available in the database?
SELECT
    country_id,
    iso_code,
    country_name,
    who_region
FROM country
ORDER BY country_name;


-- Q7. What years are covered by the vaccination coverage data?
SELECT
    MIN(year) AS earliest_year,
    MAX(year) AS latest_year
FROM coverage;


-- Q8. What years are covered by the incidence data?
SELECT
    MIN(year) AS earliest_year,
    MAX(year) AS latest_year
FROM incidence;


-- Q9. How many vaccine introduction records are present?
SELECT COUNT(*) AS total_vaccine_introduction_records
FROM vaccine_introduction;


-- Q10. How many vaccine schedule records are present?
SELECT COUNT(*) AS total_vaccine_schedule_records
FROM vaccine_schedule;

-- ============================================================
-- MEDIUM QUESTIONS
-- ============================================================


-- Q11. What is the average vaccination coverage by year?
SELECT
    year,
    ROUND(AVG(coverage), 2) AS average_coverage
FROM coverage
WHERE coverage IS NOT NULL
GROUP BY year
ORDER BY year;


-- Q12. What is the average vaccination coverage by country?
SELECT
    c.country_name,
    ROUND(AVG(cv.coverage), 2) AS average_coverage
FROM coverage cv
JOIN country c
    ON cv.country_id = c.country_id
WHERE cv.coverage IS NOT NULL
GROUP BY c.country_name
ORDER BY average_coverage DESC;


-- Q13. What is the average incidence rate by disease?
SELECT
    d.disease_description,
    ROUND(AVG(i.incidence_rate), 2) AS average_incidence_rate
FROM incidence i
JOIN disease d
    ON i.disease_id = d.disease_id
WHERE i.incidence_rate IS NOT NULL
GROUP BY d.disease_description
ORDER BY average_incidence_rate DESC;


-- Q14. What is the total number of reported cases by disease?
SELECT
    d.disease_description,
    SUM(rc.cases) AS total_reported_cases
FROM reported_cases rc
JOIN disease d
    ON rc.disease_id = d.disease_id
WHERE rc.cases IS NOT NULL
GROUP BY d.disease_description
ORDER BY total_reported_cases DESC;


-- Q15. What is the average vaccination coverage by WHO region?
SELECT
    c.who_region,
    ROUND(AVG(cv.coverage), 2) AS average_coverage
FROM coverage cv
JOIN country c
    ON cv.country_id = c.country_id
WHERE cv.coverage IS NOT NULL
GROUP BY c.who_region
ORDER BY average_coverage DESC;


-- Q16. How many vaccine introductions occurred in each year?
SELECT
    year,
    COUNT(*) AS vaccine_introductions
FROM vaccine_introduction
GROUP BY year
ORDER BY year;


-- Q17. How many vaccine schedule records exist for each WHO region?
-- Q17. How many vaccine schedule records exist for each WHO region?
SELECT
    c.who_region,
    COUNT(*) AS schedule_records
FROM vaccine_schedule vs
JOIN country c
    ON vs.country_id = c.country_id
GROUP BY c.who_region
ORDER BY schedule_records DESC;


-- Q18. What is the average vaccination coverage for each antigen?
SELECT
    antigen,
    ROUND(AVG(coverage), 2) AS average_coverage
FROM coverage
WHERE coverage IS NOT NULL
GROUP BY antigen
ORDER BY average_coverage DESC;


-- Q19. What is the yearly total number of reported disease cases?
SELECT
    year,
    SUM(cases) AS total_reported_cases
FROM reported_cases
WHERE cases IS NOT NULL
GROUP BY year
ORDER BY year;


-- Q20. Which countries have an average vaccination coverage above 80%?
SELECT
    c.country_name,
    ROUND(AVG(cv.coverage), 2) AS average_coverage
FROM coverage cv
JOIN country c
    ON cv.country_id = c.country_id
WHERE cv.coverage IS NOT NULL
GROUP BY c.country_name
HAVING AVG(cv.coverage) > 80
ORDER BY average_coverage DESC;

-- ============================================================
-- SCENARIO-BASED QUESTIONS
-- ============================================================


-- Q21. Which countries have vaccination coverage below 50%?
SELECT
    c.country_name,
    ROUND(AVG(cv.coverage), 2) AS average_coverage
FROM coverage cv
JOIN country c
    ON cv.country_id = c.country_id
WHERE cv.coverage IS NOT NULL
GROUP BY c.country_name
HAVING AVG(cv.coverage) < 50
ORDER BY average_coverage;


-- Q22. Which diseases have the highest average incidence rate?
SELECT
    d.disease_description,
    ROUND(AVG(i.incidence_rate), 2) AS average_incidence_rate
FROM incidence i
JOIN disease d
    ON i.disease_id = d.disease_id
WHERE i.incidence_rate IS NOT NULL
GROUP BY d.disease_description
ORDER BY average_incidence_rate DESC;


-- Q23. Which countries have both vaccination coverage above 90%
-- and reported disease cases?
-- Q23. Which countries have both vaccination coverage above 90%
-- and reported disease cases?

SELECT
    c.country_name,
    cv.average_coverage,
    rc.total_reported_cases
FROM country c

JOIN (
    SELECT
        country_id,
        ROUND(AVG(coverage), 2) AS average_coverage
    FROM coverage
    WHERE coverage IS NOT NULL
    GROUP BY country_id
    HAVING AVG(coverage) > 90
) cv
    ON c.country_id = cv.country_id

JOIN (
    SELECT
        country_id,
        SUM(cases) AS total_reported_cases
    FROM reported_cases
    WHERE cases IS NOT NULL
    GROUP BY country_id
) rc
    ON c.country_id = rc.country_id

ORDER BY cv.average_coverage DESC;


-- Q24. What is the yearly average vaccination coverage and
-- total reported disease cases?
-- Q24. What is the yearly average vaccination coverage
-- and total reported disease cases?

SELECT
    cv.year,
    cv.average_coverage,
    rc.total_reported_cases
FROM (
    SELECT
        year,
        ROUND(AVG(coverage), 2) AS average_coverage
    FROM coverage
    WHERE coverage IS NOT NULL
    GROUP BY year
) cv

JOIN (
    SELECT
        year,
        SUM(cases) AS total_reported_cases
    FROM reported_cases
    WHERE cases IS NOT NULL
    GROUP BY year
) rc
    ON cv.year = rc.year

ORDER BY cv.year;


-- Q25. Which countries have reported disease cases despite
-- having average vaccination coverage above 80%?
-- Q25. Which countries have vaccination coverage above 80%
-- and more than 0 reported disease cases?

SELECT
    c.country_name,
    cv.average_coverage,
    rc.total_reported_cases
FROM country c

JOIN (
    SELECT
        country_id,
        ROUND(AVG(coverage), 2) AS average_coverage
    FROM coverage
    WHERE coverage IS NOT NULL
    GROUP BY country_id
    HAVING AVG(coverage) > 80
) cv
    ON c.country_id = cv.country_id

JOIN (
    SELECT
        country_id,
        SUM(cases) AS total_reported_cases
    FROM reported_cases
    WHERE cases IS NOT NULL
    GROUP BY country_id
    HAVING SUM(cases) > 0
) rc
    ON c.country_id = rc.country_id

ORDER BY rc.total_reported_cases DESC;


-- Q26. Which diseases have both reported cases and
-- incidence-rate data?
-- Q26. For each disease, how many countries have reported cases
-- and how many countries have incidence data?

SELECT
    d.disease_description,
    COALESCE(rc.countries_with_reported_cases, 0) AS countries_with_reported_cases,
    COALESCE(i.countries_with_incidence_data, 0) AS countries_with_incidence_data
FROM disease d

LEFT JOIN (
    SELECT
        disease_id,
        COUNT(DISTINCT country_id) AS countries_with_reported_cases
    FROM reported_cases
    WHERE cases IS NOT NULL
    GROUP BY disease_id
) rc
    ON d.disease_id = rc.disease_id

LEFT JOIN (
    SELECT
        disease_id,
        COUNT(DISTINCT country_id) AS countries_with_incidence_data
    FROM incidence
    WHERE incidence_rate IS NOT NULL
    GROUP BY disease_id
) i
    ON d.disease_id = i.disease_id

ORDER BY d.disease_description;

-- Q27. Which countries have the largest number of
-- vaccine introduction records?
SELECT
    c.country_name,
    COUNT(*) AS vaccine_introduction_records
FROM vaccine_introduction vi
JOIN country c
    ON vi.country_id = c.country_id
GROUP BY c.country_name
ORDER BY vaccine_introduction_records DESC;


-- Q28. Which countries have vaccine schedule information
-- and vaccination coverage information?
-- Q28. For each country, compare vaccine schedule records
-- with vaccination coverage records.

SELECT
    c.country_name,
    COALESCE(vs.schedule_records, 0) AS schedule_records,
    COALESCE(cv.coverage_records, 0) AS coverage_records
FROM country c

LEFT JOIN (
    SELECT
        country_id,
        COUNT(*) AS schedule_records
    FROM vaccine_schedule
    GROUP BY country_id
) vs
    ON c.country_id = vs.country_id

LEFT JOIN (
    SELECT
        country_id,
        COUNT(*) AS coverage_records
    FROM coverage
    GROUP BY country_id
) cv
    ON c.country_id = cv.country_id

ORDER BY coverage_records DESC;

-- Q29. Which years had both vaccine introductions and
-- reported disease cases?
-- Q29. Compare yearly vaccine introductions
-- with total reported cases.

SELECT
    vi.year,
    vi.vaccine_introductions,
    rc.total_reported_cases
FROM (
    SELECT
        year,
        COUNT(DISTINCT introduction_id) AS vaccine_introductions
    FROM vaccine_introduction
    GROUP BY year
) vi

JOIN (
    SELECT
        year,
        SUM(cases) AS total_reported_cases
    FROM reported_cases
    WHERE cases IS NOT NULL
    GROUP BY year
) rc
    ON vi.year = rc.year

ORDER BY vi.year;

-- Q30. Compare average incidence rate
-- with total reported cases for each disease.

SELECT
    d.disease_description,
    i.average_incidence_rate,
    rc.total_reported_cases
FROM disease d

JOIN (
    SELECT
        disease_id,
        ROUND(AVG(incidence_rate), 2) AS average_incidence_rate
    FROM incidence
    WHERE incidence_rate IS NOT NULL
    GROUP BY disease_id
) i
    ON d.disease_id = i.disease_id

JOIN (
    SELECT
        disease_id,
        SUM(cases) AS total_reported_cases
    FROM reported_cases
    WHERE cases IS NOT NULL
    GROUP BY disease_id
) rc
    ON d.disease_id = rc.disease_id

ORDER BY i.average_incidence_rate DESC;