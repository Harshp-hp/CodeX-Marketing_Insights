-- Overview the tables of beverages 

SELECT * FROM dim_cities;
SELECT * FROM dim_repondents;
SELECT * FROM fact_survey_response;


-- Demographic Insights`

-- 1. Who Prefers energy drink more?

SELECT 
	gender AS Gender,
    COUNT((respondent_id)/1000000) AS Total_respondents_mlns
FROM
    dim_repondents
GROUP BY gender
ORDER BY 2 DESC;

-- 2. Which age group prefers energy drinks more?

SELECT 
    age AS Age,
    COUNT((respondent_id) / 1000000) AS Total_Respondents_mln
FROM
    dim_repondents
GROUP BY age
ORDER BY 2 DESC;

-- 3. Which type of marketing reaches the most youth (15-30)?

SELECT 
    dr.age,
    sr.marketing_channels,
    COUNT(sr.respondent_id) AS Total_Respondents
FROM
    dim_repondents dr
        JOIN
    fact_survey_response sr ON dr.respondent_id = sr.respondent_id
WHERE dr.age IN ("15-18" , "19-30")    
GROUP BY dr.age , sr.marketing_channels
ORDER BY 3 DESC;


-- Consumer Preferences 

-- 1. What are the preferred ingredients of energy drinks among respondents?

SELECT 
    ingredients_expected,
    COUNT(respondent_id) AS Total_count_respondents
FROM
    fact_survey_response
GROUP BY ingredients_expected
ORDER BY 2 DESC;        

-- 2. What packaging preferneces do respondents have for energy drinks?
WITH Packaging_design AS (
SELECT 
    packaging_prederence AS 'Packing References',
    COUNT(respondent_id) AS Total_respondents
FROM
    fact_survey_response
GROUP BY packaging_prederence
ORDER BY 2 DESC)
SELECT *,
	ROUND(Total_respondents * 100 / SUM(Total_respondents) OVER() ,2 ) AS Percentage
FROM packaging_design;    
        
-- Competition Analysis 

-- 1. Who are the current market leaders?

SELECT 
    current_brands, 
    COUNT(respondent_id) AS Total_Respondents
FROM
    fact_survey_response
GROUP BY current_brands
ORDER BY 2 DESC;    

-- 2. What are the primary reasons consumers prefer those brands over ours?
WITH brands AS (
	SELECT 
    current_brands, COUNT(respondent_id) AS Total_Respondents
FROM
    fact_survey_response
GROUP BY current_brands
ORDER BY Total_Respondents DESC
)
SELECT 
    b.current_brands AS current_brands,
    sr.resaons_for_choosing_brands AS reasons_choosing_brands,
    COUNT(sr.resaons_for_choosing_brands) AS Total_Response_Over_Choose
FROM
    brands b
        JOIN
    fact_survey_response sr USING (current_brands)
GROUP BY b.current_brands , sr.resaons_for_choosing_brands 
ORDER BY current_brands , Total_Response_Over_Choose DESC;
		
    
-- Marketing Channels And Brand Awareness 

-- 1. Which marketing channel can be used to reach more customers?

SELECT 
    marketing_channels, COUNT(respondent_id) AS Total_repondents
FROM
    fact_survey_response
GROUP BY marketing_channels
ORDER BY 2 DESC;  

-- 2. How effective are different marketing strategies and channels in reaching our customers?

WITH marketing_channels AS (
	SELECT 
		marketing_channels, COUNT(respondent_id) AS Total_Respondents
	FROM
		fact_survey_response
	GROUP BY marketing_channels
    )
    SELECT *,
		ROUND(Total_Respondents*100/ SUM(Total_Respondents) OVER(), 2) AS 'Effectiveness_pct'
    FROM marketing_channels
    ORDER BY Effectiveness_pct DESC;    


-- Brand Penetration 

-- 1. What do people thinl about our brand? (Overall Rating)

SELECT
	taste_experience AS Overall_Rating,
    COUNT(respondent_id) AS Total_respondents
FROM 
		fact_survey_response
WHERE 
			current_brands = "CodeX"
GROUP BY Overall_Rating
ORDER BY 2 DESC;            


-- 2. Which cities do we need to focus more ?

SELECT 
	c.city AS City, 
    COUNT(sr.respondent_id) AS Customer_count
FROM 
		dim_cities c
JOIN 
	fact_survey_response_city sr USING(city_id)
WHERE 
	sr.current_brands = 'CodeX'
 GROUP BY c.city
 ORDER BY 2 DESC;

-- Purchase Behaviour 

-- 1. Where do respondents prefer to purchase energy drinks?
WITH Prefered_Locations AS (
	SELECT 
		purchase_location,
		COUNT(respondent_id) AS customer_count
	FROM 
			fact_survey_response
    GROUP BY purchase_location        
)
SELECT 
	*,
	ROUND(customer_count * 100 / SUM(customer_count) OVER(),2) AS 'Respondents_pct_Location'
FROM prefered_locations
ORDER BY 2 DESC;   

-- 2. What are the typical consumption situations for energy drinks among respondents?

WITH consumption_situation AS (
	SELECT 
		typical_consumption_situations,
        COUNT(respondent_id) AS Customer_count
    FROM 
		fact_survey_response
    GROUP BY typical_consumption_situations
)
SELECT 
		*,
        ROUND(Customer_count *100/ SUM(Customer_count) OVER(), 2) AS Customer_pct
FROM 
			consumption_situation
ORDER BY 2 DESC;            

-- 3. What factors influence respondents' purchase decisions, such as price range and limited edition packaging?

-- A. Price Ranges
WITH price_ranges AS (
	SELECT
		price_range,
        COUNT(respondent_id) AS Customer_Count
    FROM
		fact_survey_response
    GROUP BY price_range
    )
 SELECT 
	*,
    ROUND(Customer_count * 100 / SUM(Customer_count) OVER(), 2) AS Customer_pct
 FROM 
	price_ranges
 ORDER BY 2 DESC;   
 
 -- B. Limited edition Packaging
 
WITH limited_edition_pack AS (
	SELECT 
		limited_edition_packaging,
        COUNT(respondent_id) AS Customer_count
    FROM 
		fact_survey_response
    GROUP BY limited_edition_packaging
 )
 SELECT 
	*,
    ROUND(Customer_count * 100 / SUM(Customer_count) OVER(),2) AS Customer_pct
 FROM limited_edition_pack
 ORDER BY 2 DESC;
 
 
-- D. Interest_in_natural_or_organice

WITH natural_organic AS (
	SELECT 
		interest_in_natural_or_organic,
        COUNT(respondent_id) AS Customer_count
    FROM 
		fact_survey_response
    GROUP BY interest_in_natural_or_organic
 )
 SELECT 
	*,
    ROUND(Customer_count * 100 / SUM(Customer_count) OVER(), 2) AS Customer_pct
 FROM 
	natural_organic
ORDER BY 2 DESC;    

-- E. Improvement_desired 

WITH improvements AS (
	SELECT 
		improvement_desired,
        COUNT(respondent_id) AS Customer_count
    FROM 
		fact_survey_response
    GROUP BY improvement_desired
)
SELECT 
		*,
        ROUND(Customer_count * 100 / SUM(Customer_count) OVER() , 2) AS Customer_pct
FROM improvements
ORDER BY 2 DESC;     

-- Product Development

-- 1. Which area of business should we focus more on our product development? (Branding/taste/availability)
 
 -- Reasons for Choosing the brands
   SELECT 	
		resaons_for_choosing_brands,
        COUNT(respondent_id) AS Total_response
   FROM
		fact_survey_response
   WHERE 
		current_brands = 'CodeX'
   GROUP BY resaons_for_choosing_brands
   ORDER BY 2 DESC;
   
  -- Expected Ingredients
  
  SELECT 
		ingredients_expected,
        COUNT(respondent_id) AS Total_Respondent
  FROM 
		fact_survey_response
  WHERE current_brands = 'CodeX'      
  GROUP BY ingredients_expected
  ORDER BY 2 DESC;
   

-- Secondary Questions 

-- Demographics Insights 

-- a. Which age group is the most health-conscious when it comes to energy drinks?
-- Overall brand 

SELECT 
    r.age AS age,
    s.health_concerns,
    COUNT(r.respondent_id) AS Total_Response
FROM
    dim_repondents r
        JOIN
    fact_survey_response s USING (respondent_id)
GROUP BY r.age, s.health_concerns
HAVING s.health_concerns = 'Yes'
ORDER BY Total_Response DESC;   

-- FOR CodeX brand

SELECT 
    r.age AS age,
    s.health_concerns,
    s.current_brands,
    COUNT(r.respondent_id) AS Total_Response
FROM
    dim_repondents r
        JOIN
    fact_survey_response s USING (respondent_id)
WHERE 
		s.current_brands = 'CodeX'
GROUP BY r.age, s.health_concerns
HAVING s.health_concerns = 'Yes'
ORDER BY Total_Response DESC;   
     
     
-- b. How does gender influence the choice of energy drink flavours?
WITH gender_influence AS 
	(SELECT r.gender,
			s.resaons_for_choosing_brands,
			COUNT(r.respondent_id) AS Total_Response
	FROM 
				dim_repondents r 
				JOIN fact_survey_response s USING(respondent_id)
	GROUP BY r.gender, s.resaons_for_choosing_brands
	ORDER BY Total_Response DESC )
SELECT *, 
		ROUND(Total_Response *100/ SUM(Total_Response) OVER() ,2 ) AS Total_Response_PCT
FROM gender_influence;        

-- c. Do non-binary individuals have different perferences for energy drink brands compared to males and females ??

SELECT 
	r.gender AS Gender,
    s.current_brands AS Brands ,
    COUNT(r.respondent_id) AS Total_Response 
FROM 
		dim_repondents r 
JOIN 	
			fact_survey_response s  USING(respondent_id) 
GROUP BY r.gender, s.current_brands
HAVING r.gender = 'non-binary'
ORDER BY Total_Response DESC;

-- Consumer Preferences 

-- A. What are the key factors influencing consumers decision to try new energy drinks brands?

SELECT 
    reasons_preventing_trying AS Factors,
    COUNT(respondent_id) AS Total_Response
FROM
    fact_survey_response
GROUP BY Factors
ORDER BY Total_Response DESC;


-- Are Consumers willing to pay a premium  for energy drinks with natural or organic ingredients?
SELECT 
	interest_in_natural_or_organic AS Interest,
    COUNT(respondent_id) AS Total_Response,
   ROUND(COUNT(respondent_id) * 100 / (SELECT COUNT(*) FROM fact_survey_response),2) AS Percentage 
FROM 
	fact_survey_response
GROUP BY Interest
ORDER BY Percentage DESC;
    
    
-- CodeX Brands 

SELECT 
	interest_in_natural_or_organic AS Interest,
    current_brands AS Brand,
    COUNT(respondent_id) AS Total_Response,
   ROUND(COUNT(respondent_id) * 100 / (SELECT COUNT(*) FROM fact_survey_response),2) AS Percentage 
FROM 
	fact_survey_response
WHERE 
		current_brands = 'CodeX'
GROUP BY Interest
ORDER BY Percentage DESC;

-- Brand Penetration 

-- How does brand perception  differ between existing customers and potential customers?

SELECT 
	brand_perception,
    tired_before,
    current_brands,
    COUNT(respondent_id) AS Total_Response 
FROM 
		fact_survey_response
WHERE 
			current_brands = 'CodeX'
GROUP BY brand_perception, tired_before
ORDER BY tired_before,Total_Response DESC;        
    
-- Product Development 

-- Are there any new product formats or variations that consumers are interested in, such as low-sugar or caffeine-free options?


SELECT 
	improvement_desired
FROM fact_survey_response
GROUP BY 1;    

SELECT 
    SUM(CASE
        WHEN improvement_desired = 'Reduced sugar content' THEN 1
        ELSE 0
    END) AS Reduced_Sugar,
    SUM(CASE
        WHEN improvement_desired = 'More natural ingredients' THEN 1
        ELSE 0
    END) AS Natural_Ingredients,
    SUM(CASE
        WHEN improvement_desired = 'Wider range of flavours' THEN 1
        ELSE 0
    END) AS Range_Flavours,
    SUM(CASE
        WHEN improvement_desired = 'Healthier alternatives' THEN 1
        ELSE 0
    END) AS Healthier_Alternatives,
    SUM(CASE
        WHEN improvement_desired = 'Other' THEN 1
        ELSE 0
    END) AS OTHER
FROM
    fact_survey_response;    