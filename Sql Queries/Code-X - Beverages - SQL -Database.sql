-- Database of CodeX - German based beverages company..

-- Create a Database 
CREATE DATABASE CodeX_beverages;
USE CodeX_beverages;

-- Table Structure - Dim_Cities 
CREATE TABLE dim_cities 
	(
			city_id VARCHAR(8),
            city CHAR(10),
            Tier VARCHAR(10)
    );
    
-- Table Structure - Dim repondents 
DROP TABLE dim_repondents;
CREATE TABLE dim_repondents
		(
			respondent_id INT,
            Full_Name CHAR(30),
            age VARCHAR(8),
            gender CHAR(12),
            city_id VARCHAR(6)
    );
    
-- Load the dataset in the table dim_repondents 

LOAD DATA INFILE 
'I:\dim_repondents.csv'
INTO TABLE dim_repondents
FIELDS TERMINATED BY     ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Table Structure fact_survey_response 
DROP TABLE fact_survey_response;
CREATE TABLE fact_survey_response 
	(
		response_id INT,
        repondents_id INT,
        consume_frequency VARCHAR(20),
        consume_time VARCHAR(35),
        consume_reason VARCHAR(30),
        heard_before CHAR(10),
        brand_perception CHAR(10),
        general_perception CHAR(10),
        tired_before CHAR(10),
        taste_experience INT,
        reasons_preventing_trying VARCHAR(40),
        current_brands VARCHAR(10),
        resaons_for_choosing_brands VARCHAR(30),
        improvement_desired CHAR(30),
        ingredients_expected CHAR(20),
        health_concerns VARCHAR(15),
        interest_in_natural_or_organic CHAR(20),
        marketing_channels CHAR(20),
        packaging_prederence CHAR(30),
        limited_edition_packaging CHAR(10),
        price_range VARCHAR(15),
        purchase_location CHAR(40),
        typical_consumption_situations VARCHAR(30)
    );
    
-- Load the dataset in the table fact_survey 

LOAD DATA INFILE 
'I:\fact_survey_responses.csv'
INTO TABLE fact_survey_response
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
