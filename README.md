# 💳 Credit Risk Analysis

A end-to-end data analysis project analyzing 32,000+ loan records to identify 
key default predictors, segment borrowers by risk, and deliver actionable 
insights through an interactive Power BI dashboard.

---

## 📌 Key Findings

- **Grade G** borrowers default at **98%** vs **10%** for Grade A — loan grade is the #1 risk predictor
- **1 in 5** borrowers defaults — 7K losses out of 33K applicants
- **Debt consolidation** loans carry the highest default risk at 29%
- High burden borrowers default at **4x** the normal rate
- **Medium Risk tier** drives the majority of total defaults despite low individual default rate

---

## 🎯 Objective

To analyze borrower-level loan data and:
- Identify key drivers of loan default
- Segment borrowers into risk tiers
- Provide data-driven recommendations for credit risk management

---

## 🗂️ Dataset

| Detail | Info |
|---|---|
| Source | [Credit Risk Dataset — Kaggle](https://www.kaggle.com/datasets/laotse/credit-risk-dataset) |
| Rows | 32,581 |
| Columns | 12 |
| Key Fields | Loan Grade, Income, Loan Intent, Interest Rate, Loan Status |

---

## 🛠️ Tools Used

| Tool | Purpose |
|---|---|
| Python (Pandas) | Data cleaning & feature engineering |
| Python (Matplotlib, Seaborn) | Exploratory data analysis & visualization |
| MySQL | SQL-based business analysis |
| Power BI | Interactive dashboard |
| GitHub | Version control & documentation |

---

## 📁 Project Structure
```
credit-risk-analysis/
│
├── data/
│   ├── credit_risk_dataset.csv        # Raw dataset
│   └── credit_risk_cleaned.csv        # Cleaned dataset
│
├── Credit_risk_analysis.ipynb     # Python cleaning + EDA + feature engineering
│
├── credit_risk_analysis.sql       # All 11 SQL queries
│
├── dashboard/
│   ├── Credit_risk_analysis.pbix      # Power BI dashboard file
│   └── dashboard.png                  # Dashboard screenshot
│
└── README.md
```

---

## 🔄 Project Workflow
```
Raw Data → Data Cleaning → Feature Engineering → EDA → SQL Analysis → Dashboard
```

---

## 🧹 Data Cleaning (Python)

- Filled **3,116 nulls** in `loan_int_rate` with median
- Filled **895 nulls** in `person_emp_length` with median
- Removed impossible outliers: `person_age` > 80, `person_emp_length` > 60
- Final clean dataset: **32,498 rows**

---

## ⚙️ Feature Engineering (Python)

Created 3 new business-relevant features:

| Feature | Logic | Purpose |
|---|---|---|
| `risk_tier` | Based on loan_grade (A/B=Low, C/D=Medium, E/F/G=High) | Borrower risk segmentation |
| `income_band` | Low(<30K), Medium(30K-70K), High(>70K) | Income-based segmentation |
| `high_loan_burden` | loan_percent_income > 0.3 = High Burden | Debt burden flagging |

---

## 📊 Exploratory Data Analysis (Python)

8 visualizations covering:

| Chart | Type | Insight |
|---|---|---|
| Default Rate by Loan Grade | Bar Chart | Risk escalates A→G |
| Income vs Default | Box Plot | Defaulters earn less |
| Correlation Heatmap | Heatmap | loan_percent_income strongest predictor |
| Default Rate by Loan Intent | Horizontal Bar | Debt consolidation riskiest |
| Loan Amount Distribution | Histogram | Right-skewed, most loans $5K–$15K |
| Borrower Distribution by Risk Tier | Donut Chart | 65% low risk |
| Loan Status by Income Band | Grouped Bar | Low income near 50/50 split |
| Loan Burden vs Default | Stacked Bar | High burden = 70% default |

---

## 🗄️ SQL Analysis (MySQL)

11 business questions answered across 3 complexity levels:

**Level 1 — Basic**
| Q | Question | Technique |
|---|---|---|
| Q1 | Overall portfolio health | Aggregation |
| Q2 | Default rate by loan grade | GROUP BY + COUNT/SUM |
| Q3 | Income level vs default risk | GROUP BY + AVG |

**Level 2 — Intermediate**
| Q | Question | Technique |
|---|---|---|
| Q4 | Loan grade + intent combination risk | Multi-column GROUP BY + HAVING |
| Q5 | Prior default history across income bands | Multi-dimension GROUP BY |
| Q6 | Grades above portfolio average | HAVING + Subquery |
| Q7 | Defaulted vs non-defaulted profile | CASE WHEN + multiple AVGs |
| Q8 | Loan burden vs default rate | CASE WHEN + conditional aggregation |

**Level 3 — Advanced Intermediate**
| Q | Question | Technique |
|---|---|---|
| Q9 | Ranking grades by default rate | RANK() window function |
| Q10 | Above average risk borrower segment | CTE + WHERE filter |
| Q11 | Age group vs default rate | CASE WHEN + BETWEEN |

---

## 📈 Power BI Dashboard

**4 KPI Cards:**
- Total Applicants: 33K
- High Risk Exposure: 3.9%
- Default Rate: 21.82%
- Total Defaulted: 7K

**5 Visuals:**
- Default Rate by Income Band
- Default Rate by Loan Grade
- Default Rate by Loan Intent
- Borrower Distribution by Risk Tier
- Loan Burden vs Default Rate

**4 Interactive Slicers:**
- Loan Grade
- Loan Intent
- Income Band
- Risk Tier

---

## 💡 Business Recommendations

| Finding | Recommendation |
|---|---|
| Grade G defaults at 98% | Reject Grade G applications outright |
| Debt consolidation highest risk at 29% | Require additional collateral for this intent |
| High burden borrowers default 4x more | Enforce 30% loan-to-income hard limit |
| Low income borrowers near 50/50 default | Tighten approval criteria for income < 30K |
| Medium risk drives majority of defaults | Focus risk monitoring on Grade C/D borrowers |

---

## ▶️ How to Run

**Python Notebook:**
```bash
pip install pandas matplotlib seaborn
jupyter notebook Credit_risk_analysis.ipynb
```

**SQL Queries:**
```bash
# Import credit_risk_cleaned.csv into MySQL
# Run credit_risk_analysis.sql in MySQL Workbench
```

**Power BI Dashboard:**
```bash
# Open Credit_risk_analysis.pbix in Power BI Desktop
```

---

## 👩‍💻 Author

**Preethi G C**
📧 preethi.gangadkar04@gmail.com
🔗 [GitHub](https://github.com/PreethiChikkaboregowda)
📍 Bengaluru, India
