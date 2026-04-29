SELECT COUNT(*) FROM public.transactions;

select * from public.transactions;

CREATE TABLE public.transactions (
    trans_date_trans_time TIMESTAMP,
    cc_num BIGINT,
    merchant TEXT,
    category TEXT,
    amt FLOAT,
    gender TEXT,
    street TEXT,
    city TEXT,
    state TEXT,
    zip INT,
    lat FLOAT,
    long FLOAT,
    city_pop INT,
    job TEXT,
    dob DATE,
    unix_time BIGINT,
    merch_lat FLOAT,
    merch_long FLOAT,
    is_fraud INT,
    merch_zipcode FLOAT,
    age INT,
    hour INT,
    distance FLOAT,
    avg_amt_per_user FLOAT,
    amt_deviation FLOAT,
    distance_bin TEXT,
    age_group TEXT
);



-- Is fraud increasing over time

create view Daily_Fraud_Trend as

SELECT
	DATE (TRANS_DATE_TRANS_TIME) AS TXN_DATE,
	COUNT(*) AS TOTAL_TXN,
	ROUND(AVG(IS_FRAUD) * 100, 2) AS FRAUD_RATE
FROM
	PUBLIC.TRANSACTIONS
GROUP BY
	TXN_DATE
ORDER BY
	TXN_DATE DESC

--Any seasonal fraud pattern?

create view fraud_pattern as 

SELECT
	DATE_TRUNC('month', TRANS_DATE_TRANS_TIME) AS MONTH,
	ROUND(AVG(IS_FRAUD) * 100, 2) AS FRAUD_RATE
FROM
	PUBLIC.TRANSACTIONS
GROUP BY
	MONTH
ORDER BY
	MONTH

--Which merchants are most risky?
create view fraud_merchants as

SELECT
	MERCHANT,
	COUNT(*) AS TOTAL_TXN,
	SUM(IS_FRAUD) AS FRAUD_TXN,
	ROUND(AVG(IS_FRAUD) * 100, 2) AS FRAUD_RATE
FROM
	PUBLIC.TRANSACTIONS
GROUP BY
	MERCHANT
HAVING
	COUNT(*) > 20
ORDER BY
	FRAUD_RATE DESC
LIMIT
	10

--Does city size impact fraud?
create view fraud_by_city as 
SELECT
	CASE
		WHEN CITY_POP < 5000 THEN 'small city'
		WHEN CITY_POP < 20000 THEN 'mid city'
		ELSE 'large city'
	END AS CITY_TYPE,
	ROUND(AVG(IS_FRAUD) * 100, 2) AS FRAUD_RATE
FROM
	PUBLIC.TRANSACTIONS
GROUP BY
	CITY_TYPE

--Do some cards repeatedly commit fraud?

create view Same_Card as 
SELECT
	CC_NUM,
	COUNT(*) AS TOTAL_TXN,
	SUM(IS_FRAUD) AS FRAUD_TXN
FROM
	PUBLIC.TRANSACTIONS
GROUP BY
	CC_NUM
HAVING
	COUNT(*) > 2
ORDER BY
	FRAUD_TXN DESC
--Does fraud repeat after first incident?

create view repeat_fraud as 

SELECT
	CC_NUM,
	MIN(
		CASE
			WHEN IS_FRAUD = 1 THEN TRANS_DATE_TRANS_TIME
		END
	) AS FIRST_FRAUD_TIME,
	COUNT(
		CASE
			WHEN IS_FRAUD = 1 THEN 1
		END
	) AS TOTAL_FRAUD
FROM
	PUBLIC.TRANSACTIONS
GROUP BY
	CC_NUM
HAVING
	COUNT(
		CASE
			WHEN IS_FRAUD = 1 THEN 1
		END
	) > 1

--Are big transactions more risky?

create view High_Value_Fraud as 

SELECT
	CASE
		WHEN AMT < 50 THEN 'low'
		WHEN AMT < 200 THEN 'medium'
		ELSE 'high'
	END AS AMOUNT_GROUP,
	ROUND(AVG(IS_FRAUD) * 100, 2) AS FRAUD_RATE
FROM
	PUBLIC.TRANSACTIONS
GROUP BY
	AMOUNT_GROUP
ORDER BY
	FRAUD_RATE DESC

--Do fraud users transact more frequently?
create view Transaction_Frequency as 

SELECT
	CC_NUM,
	COUNT(*) AS TOTAL_TXN
FROM
	PUBLIC.TRANSACTIONS
GROUP BY
	CC_NUM
ORDER BY
	TOTAL_TXN DESC
LIMIT
	10

--Which state-category combination is most risky?

create view State_Category_Combined as 

SELECT
	STATE,
	CATEGORY,
	ROUND(AVG(IS_FRAUD) * 100, 2) AS FRAUD_RATE
FROM
	PUBLIC.TRANSACTIONS
GROUP BY
	STATE,
	CATEGORY
ORDER BY
	FRAUD_RATE DESC
LIMIT
	10

--Does fraud increase on weekends?

create view Weekend_vs_Weekday_Fraud as 

SELECT
	CASE
		WHEN EXTRACT(
			DOW
			FROM
				TRANS_DATE_TRANS_TIME
		) IN (0, 6) THEN 'weekend'
		ELSE 'weekday'
	END AS DAY_TYPE,
	ROUND(AVG(IS_FRAUD) * 100, 2) AS FRAUD_RATE
FROM
	PUBLIC.TRANSACTIONS
GROUP BY
	DAY_TYPE






