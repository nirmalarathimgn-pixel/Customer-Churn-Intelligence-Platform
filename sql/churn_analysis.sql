-- ============================================
-- CUSTOMER CHURN INTELLIGENCE PLATFORM
-- FINAL CLEAN MYSQL PROJECT
-- ============================================
DROP DATABASE churn_project;

-- ============================================
-- 1. CREATE DATABASE
-- ============================================

CREATE DATABASE churn_project;


-- ============================================
-- 2. USE DATABASE
-- ============================================

USE churn_project;


-- ============================================
-- 3. CREATE TABLE
-- ============================================

CREATE TABLE cleaned_churn_data (

    customerID VARCHAR(50),
    gender VARCHAR(20),
    SeniorCitizen INT,
    Partner VARCHAR(10),
    Dependents VARCHAR(10),
    tenure INT,
    PhoneService VARCHAR(20),
    MultipleLines VARCHAR(30),
    InternetService VARCHAR(30),
    OnlineSecurity VARCHAR(30),
    OnlineBackup VARCHAR(30),
    DeviceProtection VARCHAR(30),
    TechSupport VARCHAR(30),
    StreamingTV VARCHAR(30),
    StreamingMovies VARCHAR(30),
    Contract VARCHAR(30),
    PaperlessBilling VARCHAR(10),
    PaymentMethod VARCHAR(50),
    MonthlyCharges FLOAT,
    TotalCharges FLOAT,
    Churn INT

);


-- ============================================
-- 4. INSERT DATA
-- ============================================

INSERT INTO cleaned_churn_data VALUES

('7590-VHVEG','Female',0,'Yes','No',1,'No','No phone service','DSL','No','Yes','No','No','No','No','Month-to-month','Yes','Electronic check',29.85,29.85,0),

('5575-GNVDE','Male',0,'No','No',34,'Yes','No','DSL','Yes','No','Yes','No','No','No','One year','No','Mailed check',56.95,1889.50,0),

('3668-QPYBK','Male',0,'No','No',2,'Yes','No','DSL','Yes','Yes','No','No','No','No','Month-to-month','Yes','Mailed check',53.85,108.15,1),

('7795-CFOCW','Male',0,'No','No',45,'No','No phone service','DSL','Yes','No','Yes','Yes','No','No','One year','No','Bank transfer',42.30,1840.75,0),

('9237-HQITU','Female',0,'No','No',2,'Yes','No','Fiber optic','No','No','No','No','No','No','Month-to-month','Yes','Electronic check',70.70,151.65,1),

('9305-CDSKC','Female',0,'No','No',8,'Yes','Yes','Fiber optic','No','No','Yes','No','Yes','Yes','Month-to-month','Yes','Electronic check',99.65,820.50,1),

('1452-KIOVK','Male',0,'No','Yes',22,'Yes','Yes','Fiber optic','No','Yes','No','No','Yes','No','Month-to-month','Yes','Credit card',89.10,1949.40,0),

('6713-OKOMC','Female',0,'No','No',10,'No','No phone service','DSL','Yes','No','No','No','No','No','Month-to-month','No','Mailed check',29.75,301.90,1),

('7892-POOKP','Female',0,'Yes','No',28,'Yes','Yes','Fiber optic','No','No','Yes','Yes','Yes','Yes','Month-to-month','Yes','Electronic check',104.80,3046.05,1),

('6388-TABGU','Male',0,'No','Yes',62,'Yes','No','DSL','Yes','Yes','No','Yes','No','No','Two year','No','Bank transfer',56.15,3487.95,0);


-- ============================================
-- 5. TOTAL CUSTOMERS
-- ============================================

SELECT 
    COUNT(*) AS total_customers
FROM cleaned_churn_data;


-- ============================================
-- 6. TOTAL CHURNED CUSTOMERS
-- ============================================

SELECT 
    COUNT(*) AS churned_customers
FROM cleaned_churn_data
WHERE Churn = 1;


-- ============================================
-- 7. CHURN RATE
-- ============================================

SELECT 

    ROUND(
        AVG(Churn) * 100,
        2
    ) AS churn_rate

FROM cleaned_churn_data;


-- ============================================
-- 8. TOTAL REVENUE
-- ============================================

SELECT 

    ROUND(
        SUM(TotalCharges),
        2
    ) AS total_revenue

FROM cleaned_churn_data;


-- ============================================
-- 9. MONTHLY REVENUE LOSS
-- ============================================

SELECT 

    ROUND(
        SUM(MonthlyCharges),
        2
    ) AS revenue_loss

FROM cleaned_churn_data

WHERE Churn = 1;


-- ============================================
-- 10. CONTRACT ANALYSIS
-- ============================================

SELECT 

    Contract,

    COUNT(*) AS total_customers,

    SUM(Churn) AS churned_customers,

    ROUND(
        AVG(Churn) * 100,
        2
    ) AS churn_rate

FROM cleaned_churn_data

GROUP BY Contract

ORDER BY churn_rate DESC;


-- ============================================
-- 11. PAYMENT METHOD ANALYSIS
-- ============================================

SELECT 

    PaymentMethod,

    COUNT(*) AS customers,

    ROUND(
        AVG(Churn) * 100,
        2
    ) AS churn_rate

FROM cleaned_churn_data

GROUP BY PaymentMethod

ORDER BY churn_rate DESC;


-- ============================================
-- 12. INTERNET SERVICE ANALYSIS
-- ============================================

SELECT 

    InternetService,

    COUNT(*) AS customers,

    ROUND(
        AVG(Churn) * 100,
        2
    ) AS churn_rate,

    ROUND(
        AVG(MonthlyCharges),
        2
    ) AS avg_monthly_charge

FROM cleaned_churn_data

GROUP BY InternetService

ORDER BY churn_rate DESC;


-- ============================================
-- 13. TENURE ANALYSIS
-- ============================================

SELECT 

    CASE

        WHEN tenure <= 12 THEN '0-1 Year'

        WHEN tenure <= 24 THEN '1-2 Years'

        WHEN tenure <= 48 THEN '2-4 Years'

        ELSE '4+ Years'

    END AS tenure_group,

    COUNT(*) AS customers,

    ROUND(
        AVG(Churn) * 100,
        2
    ) AS churn_rate

FROM cleaned_churn_data

GROUP BY tenure_group

ORDER BY churn_rate DESC;


-- ============================================
-- 14. HIGH RISK CUSTOMERS
-- ============================================

SELECT 

    customerID,
    Contract,
    tenure,
    MonthlyCharges

FROM cleaned_churn_data

WHERE 

    Contract = 'Month-to-month'
    AND tenure < 12
    AND MonthlyCharges > 70;


-- ============================================

-- ============================================
SELECT 
    customerID,
    MonthlyCharges
FROM cleaned_churn_data
ORDER BY MonthlyCharges DESC;



-- ============================================
-- 16. CTE QUERY
-- ============================================

SELECT 

    Contract,

    COUNT(*) AS customers,

    ROUND(
        AVG(Churn) * 100,
        2
    ) AS churn_rate

FROM cleaned_churn_data

GROUP BY Contract

ORDER BY churn_rate DESC;


-- ============================================
-- 17. FINAL EXECUTIVE SUMMARY
-- ============================================

SELECT 

    COUNT(*) AS total_customers,

    SUM(Churn) AS total_churned_customers,

    ROUND(
        AVG(Churn) * 100,
        2
    ) AS churn_rate,

    ROUND(
        SUM(TotalCharges),
        2
    ) AS total_revenue,

    ROUND(
        SUM(
            CASE
                WHEN Churn = 1
                THEN MonthlyCharges
                ELSE 0
            END
        ),
        2
    ) AS monthly_revenue_loss

FROM cleaned_churn_data;


-- ============================================
-- END OF FINAL MYSQL PROJECT
-- ============================================
