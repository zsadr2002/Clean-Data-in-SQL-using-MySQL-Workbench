# 📦 Address Normalization SQL Project

This project focuses on **normalizing semicolon-separated address strings** stored in a single column of the `people` table in the `company` database. The goal is to extract the `street`, `city`, `state`, and `zip` code from each address and store them in a separate `address` table with proper structure and integrity.

---

## 📋 Project Overview

### Input Table
- **Table Name**: `people`
- **Relevant Column**: `address` (format: `street;city;state;zip`)
- **Primary Key**: `id`

### Output Table
- **Table Name**: `address`
- **Columns**:
  - `id`: Auto-incremented primary key
  - `street`, `city`, `state`, `zip`: Extracted components of the address
  - `pfk`: Foreign key referencing `people.id`

---

## 🧠 Key Steps & SQL Queries

1. **View All People Records**
   ```sql
   SELECT * FROM people;
   ```

2. **Identify Malformed Addresses**
   ```sql
   SELECT address
   FROM people 
   WHERE address NOT REGEXP '^[0-9a-zA-Z\. ]+;[a-zA-Z ]+; [A-Z ]+;[0-9 ]+$';
   ```

3. **(Manually) Fix the Three Invalid Address Records**
   - These records don't follow the expected `street;city;state;zip` format and need manual correction.

4. **Parse Each Address Component**
   ```sql
   SELECT 
     SUBSTRING_INDEX(SUBSTRING_INDEX(address, ';', 1), ';', -1) AS street,
     SUBSTRING_INDEX(SUBSTRING_INDEX(address, ';', 2), ';', -1) AS city,
     SUBSTRING_INDEX(SUBSTRING_INDEX(address, ';', 3), ';', -1) AS state,
     SUBSTRING_INDEX(SUBSTRING_INDEX(address, ';', 4), ';', -1) AS zip
   FROM people;
   ```

5. **Create the Normalized Address Table**
   ```sql
   CREATE TABLE address (
     id INT NOT NULL AUTO_INCREMENT,
     street VARCHAR(255) NOT NULL,
     city VARCHAR(255) NOT NULL,
     state VARCHAR(2) NOT NULL,
     zip VARCHAR(10) NOT NULL,
     pfk INT,
     PRIMARY KEY (id)
   );
   ```

6. **Insert Parsed Data into `address` Table**
   ```sql
   INSERT INTO address (street, city, state, zip, pfk)
   SELECT 
     TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(address, ';', 1), ';', -1)),
     TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(address, ';', 2), ';', -1)),
     TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(address, ';', 3), ';', -1)),
     TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(address, ';', 4), ';', -1)),
     id
   FROM people;
   ```

7. **Verify the Result with a Join**
   ```sql
   SELECT * 
   FROM company.people, company.address
   WHERE people.id = address.pfk;
   ```

---

## 🔍 Summary

This SQL project transforms unstructured address data into a normalized form that adheres to relational database best practices. It uses pattern matching, string parsing, and table joins to ensure data quality and maintainability.

---

## 🛠️ Skills Used

- SQL string functions (`SUBSTRING_INDEX`, `TRIM`)
- Regular expressions for data validation
- Data normalization and table design
- Foreign key-based table joins

---

## 📌 Notes

- Only three addresses were found to be malformed and were manually corrected.
- The project assumes address format consistency after cleanup.
- Future improvements may include constraints, triggers, or stored procedures for data integrity.