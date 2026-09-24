DROP TABLE IF EXISTS vaccine_schedule;
DROP TABLE IF EXISTS vaccine_introduction;
DROP TABLE IF EXISTS reported_cases;
DROP TABLE IF EXISTS incidence;
DROP TABLE IF EXISTS coverage;
DROP TABLE IF EXISTS disease;
DROP TABLE IF EXISTS country;

USE vaccination_analytics;


-- ============================================================
-- 1. COUNTRY TABLE
-- ============================================================

CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    iso_code VARCHAR(50) NOT NULL UNIQUE,
    country_name VARCHAR(150) NOT NULL,
    who_region VARCHAR(20)
);


-- ============================================================
-- 2. COVERAGE TABLE
-- ============================================================

CREATE TABLE coverage (
    coverage_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    year INT NOT NULL,
    antigen VARCHAR(50),
    antigen_description VARCHAR(255),
    coverage_category VARCHAR(50),
    coverage_category_description VARCHAR(255),
    target_number DOUBLE,
    doses DOUBLE,
    coverage DOUBLE,

    FOREIGN KEY (country_id)
        REFERENCES country(country_id)
);


-- ============================================================
-- 3. DISEASE TABLE
-- ============================================================

CREATE TABLE disease (
    disease_id INT AUTO_INCREMENT PRIMARY KEY,
    disease_code VARCHAR(50) NOT NULL UNIQUE,
    disease_description VARCHAR(255)
);


-- ============================================================
-- 4. INCIDENCE TABLE
-- ============================================================

CREATE TABLE incidence (
    incidence_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    disease_id INT NOT NULL,
    year INT NOT NULL,
    denominator VARCHAR(100),
    incidence_rate DOUBLE,
    FOREIGN KEY (country_id) REFERENCES country(country_id),
    FOREIGN KEY (disease_id) REFERENCES disease(disease_id)
);



-- ============================================================
-- 5. REPORTED CASES TABLE
-- ============================================================

CREATE TABLE reported_cases (
    reported_cases_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    disease_id INT NOT NULL,
    year INT NOT NULL,
    cases DOUBLE,

    FOREIGN KEY (country_id)
        REFERENCES country(country_id),

    FOREIGN KEY (disease_id)
        REFERENCES disease(disease_id)
);


-- ============================================================
-- 6. VACCINE INTRODUCTION TABLE
-- ============================================================

CREATE TABLE vaccine_introduction (
    introduction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    year INT NOT NULL,
    vaccine_description VARCHAR(255),
    intro VARCHAR(50),

    FOREIGN KEY (country_id)
        REFERENCES country(country_id)
);


-- ============================================================
-- 7. VACCINE SCHEDULE TABLE
-- ============================================================

CREATE TABLE vaccine_schedule (
    schedule_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    country_id INT NOT NULL,
    year INT NOT NULL,
    vaccine_code VARCHAR(50),
    vaccine_description VARCHAR(255),
    schedule_rounds VARCHAR(50),
    target_pop VARCHAR(100),
    target_pop_description VARCHAR(255),
    geoarea VARCHAR(100),
    age_administered VARCHAR(100),
    source_comment TEXT,

    FOREIGN KEY (country_id)
        REFERENCES country(country_id)
);


-- ============================================================
-- CHECK TABLES
-- ============================================================

SHOW TABLES;