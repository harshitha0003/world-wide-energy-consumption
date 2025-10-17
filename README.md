# world-wide-energy-consumption (SQL)
# 🌍 Worldwide Energy Consumption Analysis – SQL Project  

## 📘 Project Overview  
This project focuses on analyzing **global energy consumption patterns** using **SQL**. The objective is to study how different countries consume, produce, and emit energy, and how factors like **GDP, population, and renewable production** influence energy trends worldwide.  

By using multiple interconnected tables, the analysis explores **energy dependencies, renewable adoption, and environmental impact** across different regions and years.  

---

## 🧩 Database Design  

The database was designed to represent various aspects of worldwide energy data through relational tables.  

### **1. `consume` Table**  
Stores data related to total energy consumption across countries and years.  

| Column Name | Data Type | Description |
|--------------|------------|-------------|
| `country_id` | INT | Foreign key referencing `country` table |
| `year` | INT | Year of record |
| `energy_type` | VARCHAR | Type of energy source (e.g., coal, oil, solar) |
| `consumption` | FLOAT | Energy consumed (TWh) |

---

### **2. `country` Table**  
Contains basic details about each country.  

| Column Name | Data Type | Description |
|--------------|------------|-------------|
| `country_id` | INT (PK) | Unique identifier for each country |
| `country_name` | VARCHAR | Name of the country |
| `region` | VARCHAR | Geographical region of the country |

---

### **3. `emission` Table**  
Tracks CO₂ and greenhouse gas emissions over time.  

| Column Name | Data Type | Description |
|--------------|------------|-------------|
| `country_id` | INT | Foreign key referencing `country` table |
| `year` | INT | Year of record |
| `co2_emission` | FLOAT | CO₂ emission (in metric tons) |
| `methane_emission` | FLOAT | Methane emission (optional) |

---

### **4. `gdp` Table**  
Represents the economic performance of each country.  

| Column Name | Data Type | Description |
|--------------|------------|-------------|
| `country_id` | INT | Foreign key referencing `country` table |
| `year` | INT | Year of record |
| `gdp_value` | FLOAT | GDP in USD (billions/trillions) |

---

### **5. `population` Table**  
Stores the population size of each country by year.  

| Column Name | Data Type | Description |
|--------------|------------|-------------|
| `country_id` | INT | Foreign key referencing `country` table |
| `year` | INT | Year of record |
| `population_count` | BIGINT | Total population of the country |

---

### **6. `production` Table**  
Captures energy production data across various energy types.  

| Column Name | Data Type | Description |
|--------------|------------|-------------|
| `country_id` | INT | Foreign key referencing `country` table |
| `year` | INT | Year of record |
| `energy_type` | VARCHAR | Type of energy source |
| `production` | FLOAT | Energy produced (TWh) |

---

## ⚙️ SQL Operations  

The SQL scripts in **`project_queries.sql`** include all major operations performed during the analysis:  

- **Database Creation**: Structured schema with foreign key relationships.  
- **Data Insertion**: Inserting sample or real-world energy data.  
- **Joins**: Combining multiple tables (e.g., `consume` + `emission` + `gdp`) for comparative analysis.  
- **Aggregations**: Calculating total and average consumption, production, and emissions.  
- **Filtering**: Extracting data by year, energy source, or region.  
- **Window Functions**: Ranking countries by consumption, GDP, or renewable share.  
- **Subqueries and CTEs**: Used to identify high-efficiency or high-emission countries.  

---

## 📊 Key Insights  

- Countries with **higher GDP** generally show greater energy consumption.  
- **Renewable energy production** has steadily increased over the last decade.  
- **CO₂ emissions** correlate strongly with fossil fuel consumption.  
- **Population growth** impacts total energy demand significantly.  
- Emerging economies are **adopting clean energy** faster than expected.  

---

## 🚀 Outcomes  

The project demonstrates how **SQL can power end-to-end data analytics** — from relational data design to meaningful insight generation.  
It serves as a strong foundation for energy economists, data analysts, and sustainability researchers aiming to:  
- Track global energy transitions  
- Understand environmental impact  
- Analyze relationships between energy, economy, and population  

---

## 🧠 Tech Stack  

| Category | Tools / Technologies |
|-----------|----------------------|
| **Database** | MySQL / PostgreSQL |
| **Language** | SQL |
| **Interface Tools** | MySQL Workbench / DBeaver |
| **Core Concepts** | Joins, CTEs, Aggregations, Subqueries, Window Functions |

 


