CREATE DATABASE loan;

select count(*) from credit_risk_cleaned;

select * from credit_risk_cleaned
limit 5;

# Fixing encoding issue in column name caused during CSV import
ALTER TABLE credit_risk_cleaned RENAME COLUMN `Ï»¿person_age` TO `person_age`; 

-- 1. What is the overall health of the loan portfolio?
SELECT 
    COUNT(*) AS total_borrowers,
    SUM(loan_status) AS total_defaults,
    ROUND(SUM(loan_status) * 100.0 / COUNT(*), 2) AS overall_default_rate
FROM credit_risk_cleaned;
# Establishes baseline: 1 in 5 borrowers defaults, signaling significant portfolio risk

-- 2. Which loan grades are highest risk?
select loan_grade, 
	   count(*) as total_loans,
       sum(loan_status) as defaults,
       round(SUM(loan_status) * 100.0 / COUNT(*), 2) AS default_rate
from credit_risk_cleaned
group by loan_grade
order by loan_grade;
# Default rate climbs steadily from Grade A (10%) to Grade G (98%) — grade is the #1 risk signal

-- 3. Does income level predict default risk?
select income_band,
	   count(*) as total_borrowers,
       sum(loan_status) as defaults,
       round(sum(loan_status)*100.0 / count(*), 2) as default_rate
from credit_risk_cleaned
group by income_band
order by default_rate desc;
# Low income borrowers default at 47% — nearly 4x higher than high income borrowers at 11%

-- 4. Which combination of loan grade + loan intent is most dangerous?
select loan_intent, loan_grade,
	   count(*) as total_loan,
       round(sum(loan_status)*100.0 / count(*), 2) as default_rate
from credit_risk_cleaned
group by loan_intent, loan_grade
having count(*) > 50
order by default_rate desc
limit 10;
# Dual-factor risk analysis reveals specific grade-intent combos that are near-certain defaults

-- 5. Do borrowers with a history of default behave differently across income bands?
SELECT 
    cb_person_default_on_file AS prior_default,
    income_band,
    COUNT(*) AS total_borrowers,
    ROUND(SUM(loan_status) * 100.0 / COUNT(*), 2) AS current_default_rate,
    ROUND(AVG(loan_int_rate), 2) AS avg_interest_rate
FROM credit_risk_cleaned
GROUP BY cb_person_default_on_file, income_band
ORDER BY current_default_rate DESC;
# Prior defaulters show consistently higher current default rates across all income levels

-- 6. Which loan grades have default rate above overall average?
SELECT 
    loan_grade,
    ROUND(SUM(loan_status) * 100.0 / COUNT(*), 2) AS default_rate_pct
FROM credit_risk_cleaned
GROUP BY loan_grade
HAVING default_rate_pct > (
    SELECT ROUND(SUM(loan_status) * 100.0 / COUNT(*), 2)
    FROM credit_risk_cleaned
)
ORDER BY default_rate_pct DESC;
# Identifies grades that exceed portfolio average — actionable threshold for risk policy

-- 7. Average Profile of Defaulted vs Non-Defaulted Borrowers
SELECT 
    CASE WHEN loan_status = 1 THEN 'Defaulted'
         ELSE 'Non-Defaulted'
    END AS borrower_type,
    ROUND(AVG(person_age), 1) AS avg_age,
    ROUND(AVG(person_income), 0) AS avg_income,
    ROUND(AVG(loan_amnt), 0) AS avg_loan_amount,
    ROUND(AVG(loan_int_rate), 2) AS avg_interest_rate,
    ROUND(AVG(loan_percent_income), 2) AS avg_loan_to_income
FROM credit_risk_cleaned
GROUP BY borrower_type;
# Defaulters earn less, borrow more, and pay higher interest — a compounding risk profile

-- 8.  Ranking Loan Grades by Default Rate
SELECT 
    loan_grade,
    COUNT(*) AS total_borrowers,
    ROUND(SUM(loan_status) * 100.0 / COUNT(*), 2) AS default_rate_pct,
    RANK() OVER (ORDER BY SUM(loan_status) * 100.0 / COUNT(*) DESC) AS risk_rank,
    ROUND(AVG(loan_int_rate), 2) AS avg_interest_rate
FROM credit_risk_cleaned
GROUP BY loan_grade
ORDER BY risk_rank;
# High burden borrowers (>30% income on loan) default at 70% vs 15% for normal burden

-- 9. Loan Burden vs Default Rate
SELECT 
    CASE 
        WHEN loan_percent_income > 0.3 THEN 'High Burden (>30%)'
        ELSE 'Normal Burden (<=30%)'
    END AS loan_burden,
    COUNT(*) AS total_borrowers,
    SUM(loan_status) AS total_defaults,
    ROUND(SUM(loan_status) * 100.0 / COUNT(*), 2) AS default_rate_pct,
    ROUND(AVG(person_income), 0) AS avg_income,
    ROUND(AVG(loan_amnt), 0) AS avg_loan_amount
FROM credit_risk_cleaned
GROUP BY loan_burden
ORDER BY default_rate_pct DESC;
# Window function ranks grades 1-7 — Grade G is 10x riskier than Grade A

-- 10. Above Average Risk Borrower Segment
WITH avg_metrics AS (
    SELECT 
        AVG(loan_int_rate) AS avg_rate,
        AVG(loan_percent_income) AS avg_burden
    FROM credit_risk_cleaned
)
SELECT 
    loan_grade,
    COUNT(*) AS total_borrowers,
    ROUND(SUM(loan_status) * 100.0 / COUNT(*), 2) AS default_rate_pct,
    ROUND(AVG(loan_int_rate), 2) AS avg_interest_rate,
    ROUND(AVG(loan_percent_income), 2) AS avg_loan_burden
FROM credit_risk_cleaned, avg_metrics
WHERE loan_int_rate > avg_rate 
AND loan_percent_income > avg_burden
GROUP BY loan_grade
ORDER BY default_rate_pct DESC;
# CTE isolates double high-risk borrowers, those above average on both key risk metrics

-- 11. Do Younger Borrowers Default More Than Older Borrowers?
SELECT 
    CASE 
        WHEN person_age BETWEEN 20 AND 30 THEN '20-30'
        WHEN person_age BETWEEN 31 AND 40 THEN '31-40'
        WHEN person_age BETWEEN 41 AND 50 THEN '41-50'
        ELSE '50+'
    END AS age_group,
    COUNT(*) AS total_borrowers,
    SUM(loan_status) AS total_defaults,
    ROUND(SUM(loan_status) * 100.0 / COUNT(*), 2) AS default_rate_pct,
    ROUND(AVG(loan_amnt), 0) AS avg_loan_amount,
    ROUND(AVG(person_income), 0) AS avg_income
FROM credit_risk_cleaned
GROUP BY age_group
ORDER BY default_rate_pct DESC;
# 20-30 age group shows highest default rate — lower income and shorter credit history explains this