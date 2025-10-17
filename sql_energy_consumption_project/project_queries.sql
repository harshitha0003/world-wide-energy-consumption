CREATE DATABASE ENERGYDB2;
USE ENERGYDB2;
-- 1. country table
CREATE TABLE country (
    CID VARCHAR(10) PRIMARY KEY,
    Country VARCHAR(100) UNIQUE
);

SELECT * FROM COUNTRY;

-- 2. emission_3 table
CREATE TABLE emission_3 (
    country VARCHAR(100),
 energy_type VARCHAR(50),
    year INT,
    emission INT,
    per_capita_emission DOUBLE,
    FOREIGN KEY (country) REFERENCES country(Country)
);

SELECT * FROM EMISSION_3;


-- 3. population table
CREATE TABLE population (
    countries VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (countries) REFERENCES country(Country)
);

SELECT * FROM POPULATION;

-- 4. production table
CREATE TABLE production (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    production INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);


SELECT * FROM PRODUCTION;

-- 5. gdp_3 table
CREATE TABLE gdp_3 (
    Country VARCHAR(100),
    year INT,
    Value DOUBLE,
    FOREIGN KEY (Country) REFERENCES country(Country)
);

SELECT * FROM GDP_3;

-- 6. consumption table
CREATE TABLE consumption (
    country VARCHAR(100),
    energy VARCHAR(50),
    year INT,
    consumption INT,
    FOREIGN KEY (country) REFERENCES country(Country)
);

SELECT * FROM CONSUMPTION;

# =================== General & Comparative Analysis ====================

# 1 What is the total emission per country for the most recent year available?

SELECT 
    country, 
    SUM(emission) AS total_emission
FROM emission_3
WHERE year = (SELECT MAX(year) FROM emission_3)
GROUP BY country
ORDER BY total_emission DESC;

# 2 What are the top 5 countries by GDP in the most recent year?

SELECT 
    Country,
    Value AS GDP
FROM gdp_3
WHERE year = (SELECT MAX(year) FROM gdp_3)
ORDER BY Value DESC
LIMIT 5;

# 3 Compare energy production and consumption by country and year. 

SELECT 
    country,
    year,
    SUM(production) AS total_production,
    SUM(consumption) AS total_consumption,
    (SUM(production) - SUM(consumption)) AS net_balance
FROM production p
JOIN consumption c USING (country, year, energy)
GROUP BY country, year
ORDER BY country, year;

# 4 Which energy types contribute most to emissions across all countries?

SELECT 
    energy_type,
    SUM(emission) AS total_emission
FROM emission_3
GROUP BY energy_type
ORDER BY total_emission DESC;

# ================================== Trend Analysis Over Time========================

# 1 How have global emissions changed year over year?

SELECT 
    year,
    SUM(emission) AS global_emissions,
    LAG(SUM(emission)) OVER (ORDER BY year) AS previous_year_emissions,
    ROUND(((SUM(emission) - LAG(SUM(emission)) OVER (ORDER BY year)) / LAG(SUM(emission)) OVER (ORDER BY year)) * 100, 2) AS percent_change
FROM emission_3
GROUP BY year
ORDER BY year;

# 2 What is the trend in GDP for each country over the given years?

SELECT 
    Country,
    year,
    Value AS GDP
FROM gdp_3
ORDER BY Country, year;

# 3 How has population growth affected total emissions in each country?

SELECT 
    e.country,
    e.year,
    SUM(e.emission) AS total_emissions,
    p.Value AS population
FROM emission_3 e
JOIN population p ON e.country = p.countries AND e.year = p.year
GROUP BY e.country, e.year, p.Value
ORDER BY e.country, e.year;

# 4 Has energy consumption increased or decreased over the years for major economies?

SELECT 
    country,
    year,
    SUM(consumption) AS total_consumption
FROM consumption
WHERE country IN ('United States', 'China', 'Japan', 'Germany', 'United Kingdom', 'India', 'France')
GROUP BY country, year
ORDER BY country, year;

# 5 What is the average yearly change in emissions per capita for each country?

SELECT 
    e1.country,
    ROUND(AVG(e2.per_capita_emission - e1.per_capita_emission), 4) AS avg_yearly_change
FROM emission_3 e1
JOIN emission_3 e2 ON e1.country = e2.country AND e1.year = e2.year - 1
GROUP BY e1.country
ORDER BY avg_yearly_change DESC;

# ===================Ratio & Per Capita Analysis============================

# 1 What is the emission-to-GDP ratio for each country by year?

SELECT 
    e.country,
    e.year,
    SUM(e.emission) AS total_emissions,
    g.Value AS GDP,
    ROUND(SUM(e.emission) / g.Value, 6) AS emission_gdp_ratio
FROM emission_3 e
JOIN gdp_3 g ON e.country = g.Country AND e.year = g.year
GROUP BY e.country, e.year, g.Value
ORDER BY e.country, e.year;

# 2 What is the energy consumption per capita for each country over the last decade?

SELECT 
    c.country,
    c.year,
    SUM(c.consumption) AS total_consumption,
    p.Value AS population,
    ROUND(SUM(c.consumption) / p.Value, 4) AS consumption_per_capita
FROM consumption c
JOIN population p ON c.country = p.countries AND c.year = p.year
WHERE c.year >= YEAR(CURDATE()) - 10
GROUP BY c.country, c.year, p.Value
ORDER BY c.country, c.year;

# 3 How does energy production per capita vary across countries?

SELECT 
    p.country,
    p.year,
    SUM(p.production) AS total_production,
    pop.Value AS population,
    ROUND(SUM(p.production) / pop.Value, 4) AS production_per_capita
FROM production p
JOIN population pop ON p.country = pop.countries AND p.year = pop.year
GROUP BY p.country, p.year, pop.Value
ORDER BY production_per_capita DESC;

# 4 Which countries have the highest energy consumption relative to GDP?

SELECT 
    c.country,
    c.year,
    SUM(c.consumption) AS total_consumption,
    g.Value AS GDP,
    ROUND(SUM(c.consumption) / g.Value, 6) AS consumption_gdp_ratio
FROM consumption c
JOIN gdp_3 g ON c.country = g.Country AND c.year = g.year
GROUP BY c.country, c.year, g.Value
ORDER BY consumption_gdp_ratio DESC;

# 5 What is the correlation between GDP growth and energy production growth?

SELECT 
    g.Country,
    g.year,
    g.Value AS GDP,
    SUM(p.production) AS total_production
FROM gdp_3 g
JOIN production p ON g.Country = p.country AND g.year = p.year
GROUP BY g.Country, g.year, g.Value
ORDER BY g.Country, g.year;

# ============================== Global Comparisons===============================

# 1 What are the top 10 countries by population and how do their emissions compare?

SELECT 
    p.countries AS country,
    MAX(p.Value) AS latest_population,
    (SELECT SUM(emission) 
     FROM emission_3 e 
     WHERE e.country = p.countries 
     AND e.year = (SELECT MAX(year) FROM emission_3 WHERE country = p.countries)
    ) AS latest_emissions
FROM population p
GROUP BY p.countries
ORDER BY latest_population DESC
LIMIT 10;

# 2 Which countries have improved (reduced) their per capita emissions the most over the last decade?

SELECT 
    country,
    MAX(year) AS recent_year,
    MIN(year) AS start_year,
    MAX(per_capita_emission) AS max_emission,
    MIN(per_capita_emission) AS min_emission,
    ROUND(MIN(per_capita_emission) - MAX(per_capita_emission), 4) AS reduction
FROM emission_3
WHERE year >= (SELECT MAX(year) - 10 FROM emission_3)
GROUP BY country
HAVING max_emission IS NOT NULL AND min_emission IS NOT NULL
ORDER BY reduction ASC
LIMIT 10;

# 3 What is the global share (%) of emissions by country?

SELECT 
    country,
    SUM(emission) AS total_emissions,
    ROUND(SUM(emission) / (SELECT SUM(emission) FROM emission_3) * 100, 2) AS global_share_percent
FROM emission_3
GROUP BY country
ORDER BY global_share_percent DESC;

# 4 What is the global average GDP, emission, and population by year?

SELECT 
    g.year,
    ROUND(AVG(g.Value), 2) AS avg_gdp,
    ROUND(AVG(e.emission), 2) AS avg_emission,
    ROUND(AVG(p.Value), 2) AS avg_population
FROM gdp_3 g
JOIN emission_3 e ON g.Country = e.country AND g.year = e.year
JOIN population p ON g.Country = p.countries AND g.year = p.year
GROUP BY g.year
ORDER BY g.year;