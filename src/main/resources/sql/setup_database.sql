-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS lifecare_db;

-- Use the database
USE lifecare_db;

-- Include other SQL scripts
SOURCE src/main/resources/sql/departments.sql;
