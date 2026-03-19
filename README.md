```markdown
# 🎯 Online Retail Analytics Dashboard
## Customer Segmentation & Market Basket Analysis

> Analyze 541K+ transactions to identify customer value and product bundling opportunities.

---

## 📊 Business Problem

Retail businesses struggle with:
- Which customers generate the most revenue?
- Who's at risk of churn?
- What products sell together?
- How to optimize cross-selling?

**This project answers all these questions.**

---

## 🔑 Key Results

| Metric | Finding | Business Impact |
|--------|---------|-----------------|
| **Revenue Concentration** | Top 10% customers = 40% revenue | Focus on VIP retention |
| **Repeat Customers** | 65% customers = 92.9% revenue | Build loyalty programs |
| **Purchase Cycle** | 39 days average | Email campaigns at Day 35 |
| **Product Bundles** | 80 rules, max 18.4x Lift | Cross-sell top 10 pairs |

---

## 🏗️ Architecture

```
CSV Data → SQL Cleaning → Python Analysis → RFM Segments & Rules → Power BI Dashboard
```

**Tools:**
- **SQL** → Data cleaning, RFM calculations
- **Python** → Apriori algorithm
- **Power BI** → Interactive visualizations

---

## 📈 Project Workflow

1. **Data Cleaning** (SQL) - Remove anomalies, standardize formats
2. **Feature Engineering** - Create Revenue, TransactionType, CustomerType
3. **RFM Segmentation** - Calculate Recency, Frequency, Monetary scores
4. **Market Basket** - Find product associations using Apriori
5. **Dashboard** - Visualize insights in Power BI

---

## 🔍 Technical Deep Dive

### 1️⃣ Data Cleaning (SQL)

**Challenge:** Raw data has inconsistencies
- Prices with $ signs
- Negative quantities (refunds)
- Null customer IDs

**Solution:**

```sql
-- Calculate revenue
SELECT Quantity * UnitPrice AS Revenue FROM online_retail;

-- Classify transactions
CASE 
  WHEN Quantity < 0 THEN 'Refund'
  ELSE 'Sale'
END AS TransactionType

-- Clean prices
UPDATE online_retail
SET UnitPrice = REPLACE(REPLACE(UnitPrice, '$', ''), ',', '');
ALTER TABLE online_retail MODIFY UnitPrice DECIMAL(10,2);
```

**Result:** 98.3% clean data (541,909 records)

---

### 2️⃣ Feature Engineering

Created new columns:
- **Revenue** = Quantity × UnitPrice
- **TransactionType** = Sale vs Refund
- **CustomerType** = Registered vs Anonymous
- **PriceType** = Free vs Paid

---

### 3️⃣ RFM Customer Segmentation

**RFM Metrics:**

```sql
SELECT
  CustomerID,
  DATEDIFF('2011-12-09', MAX(InvoiceDate)) AS Recency,
  COUNT(DISTINCT InvoiceNo) AS Frequency,
  SUM(Quantity * UnitPrice) AS Monetary
FROM online_retail
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID;
```

**Sample Output:**

| CustomerID | Recency | Frequency | Monetary |
|------------|---------|-----------|----------|
| 12347 | 2 | 7 | $4,310 |
| 12348 | 75 | 4 | $1,797 |
| 12349 | 18 | 1 | $1,758 |

**Segments Created:**

- **Champions** (R: 1-20, F: 4+, M: $1K+) → VIP treatment
- **Loyal Customers** (R: 20-100, F: 3+) → Cross-sell
- **Potential Loyalists** (R: 50-200, F: 1-2, M high) → Reactivate
- **At Risk** (R: 100-325, F: ≤2) → Win-back
- **Lost** (R: >325) → Archive

---

### 4️⃣ Market Basket Analysis

**Algorithm:** Apriori (finds frequent itemsets)

```python
from mlxtend.frequent_patterns import apriori, association_rules

# Find itemsets (min 2% support)
frequent_itemsets = apriori(
    df_encoded,
    min_support=0.02,
    use_colnames=True
)

# Generate rules (lift > 1)
rules = association_rules(
    frequent_itemsets,
    metric="lift",
    min_threshold=1.0
)

# Sort by lift (highest value first)
rules_sorted = rules.sort_values('lift', ascending=False)
```

**Top Product Pairs:**

| Product A | Product B | Confidence | Lift | Interpretation |
|-----------|-----------|------------|------|-----------------|
| Tea Cup | Saucer | 0.70 | 23.5 | If A bought, 70% chance B bought; 23.5x more likely |
| Mug | Coaster | 0.65 | 18.4 | Strong co-purchase pattern |
| Plate | Bowl | 0.62 | 15.3 | Bundle opportunity |

**Insight:** Products with Lift >15 should be bundled together in checkout.

---

### 5️⃣ Power BI Dashboard

**Key Visuals:**

1. **Customer Engagement Matrix**
   - X-axis: Recency (days inactive)
   - Y-axis: Frequency (orders)
   - Color: Segment
   - Shows active vs at-risk customers

2. **Product Bundle Strength**
   - X-axis: Confidence (co-purchase likelihood)
   - Y-axis: Lift (incremental value)
   - Bubble size: Transaction frequency

3. **Revenue by Segment**
   - Champions: $3.9M (40%)
   - Loyal: $3.2M (33%)
   - Others: $2.6M (27%)

4. **Segment Distribution**
   - 65% repeat customers
   - 35% one-time buyers

---

## 💡 Business Insights

### Insight #1: Revenue Concentration
Top 8% of customers (Champions) generate 40% of revenue
→ **Action:** Implement VIP loyalty program

### Insight #2: Repeat Customer Dominance
92.9% of revenue from 65% of customers
→ **Action:** Build retention campaigns

### Insight #3: Product Bundles Opportunity
80 product pairs with Lift >1 (max 23.5x)
→ **Action:** Feature bundles in checkout

### Insight #4: Purchase Cycle
Average 39 days between orders
→ **Action:** Email campaigns at Day 35

### Insight #5: Churn Risk
400 customers inactive 100+ days
→ **Action:** Win-back campaign automation

---

## 📊 Dashboard Preview

![Online Retail Performance](Images/Retail_Perfromace.png)
![Market Basket Analysis](Images/Market_Basket_Analysis.png)

---

## 🛠 Why These Tools?

| Tool | Why Used | Alternative |
|------|----------|------------|
| SQL | Efficient data cleaning & RFM | Python (slower on 541K rows) |
| Python (Apriori) | Advanced analytics, libraries | R (less common in industry) |
| Power BI | Interactive dashboard, drill-through | Tableau (more expensive) |
| Excel | Quick validation | Not scalable |

---

## 📁 Project Structure

```
Online_Retail_Analysis/
├── 📁 dashboards/
│   └── Tata.pbix                    # Interactive Power BI dashboard
├── 📁 data/
│   ├── RFM.csv                      # Customer segments (output)
│   └── Market_Basket_Rules.csv      # Product rules (output)
├── 📁 images/
│   ├── Retail_Performance.png       # Dashboard screenshot
│   └── Market_Basket_Analysis.png   # Bundle analysis screenshot
├── 📁 python/
│   └── Online-Retail.ipynb          # Apriori analysis notebook
└── 📁 sql/
    ├── 01_Data_Cleaning.sql         # Data validation
    ├── 02_Feature_Engineering.sql   # Create new columns
    └── 03_RFM_Analysis.sql          # RFM calculation


```

---

## 🚀 Quick Start

### Requirements
- Python 3.9+
- MySQL 8.0+
- Power BI Desktop

### Setup

```bash
# Clone repo
git clone https://github.com/Harsh1887/Online_Retail_Analysis.git
cd Online_Retail_Analysis

# Install dependencies
pip install pandas sqlalchemy pymysql mlxtend jupyter

# Run analysis
jupyter notebook python/Online-Retail.ipynb

# Open dashboard
Open dashboards/Tata.pbix in Power BI
```

---

## 📈 Expected Results

After running the analysis:
- **RFM.csv** → 2,000 customer segments
- **Market_Basket_Rules.csv** → 80 association rules
- **Power BI Dashboard** → 6 interactive visuals

---

## 📚 Key Metrics Explained

- **Recency** → Days since last purchase (0-325)
- **Frequency** → Number of orders (1-20+)
- **Monetary** → Total lifetime revenue ($0-$10K+)
- **Support** → % of orders with both products
- **Confidence** → If A bought, % chance B is bought
- **Lift** → Co-purchase likelihood multiplier (>1 = positive)

---

## ✨ Key Takeaways

1. **Customer Value Varies Dramatically**
   - Top 10% = 40% of revenue
   - Focused retention pays off

2. **Product Relationships Drive Revenue**
   - 23.5x lift on best pairs
   - Bundle strategy can increase AOV

3. **Data-Driven Marketing Works**
   - 39-day cycle enables timing
   - Segment strategies proven effective

4. **End-to-End Pipeline is Reproducible**
   - SQL → Python → Power BI
   - Scalable to larger datasets

---

## 🔮 Next Steps

- [ ] Build ML churn prediction model
- [ ] Create recommendation engine
- [ ] Integrate real-time data pipeline
- [ ] Expand to multi-channel analytics

---

## 👤 Author

**Harsh Gupta**  
Data Analyst 

📧 Email: [@Harsh GUpta](harshgupta1887@gmail.com)
🔗 LinkedIn: [@guptaharsh1401](https://www.linkedin.com/in/guptaharsh1401/) 
🐙 GitHub: [@Harsh1887](https://github.com/Harsh1887)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

---

## 🙏 Acknowledgments

- Algorithm: Apriori for association rule mining
- Tools: Open-source community

---



