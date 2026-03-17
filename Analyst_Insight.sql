-- 1. Average Repurchase Cycle (Time between orders)
-- Using Window Functions (LAG) to calculate the interval between consecutive purchases
WITH OrderLevelData AS (
    SELECT DISTINCT CustomerID, InvoiceNo, InvoiceDate
    FROM online_retail
    WHERE CustomerID IS NOT NULL AND Quantity > 0
),
CustomerOrders AS (
    SELECT 
        CustomerID,
        InvoiceDate,
        LAG(InvoiceDate) OVER(
            PARTITION BY CustomerID 
            ORDER BY InvoiceDate
        ) AS PreviousOrderDate
    FROM OrderLevelData
)
SELECT 
    AVG(DATEDIFF(InvoiceDate, PreviousOrderDate)) AS AverageRepurchaseCycle
FROM CustomerOrders;

-- 2. RFM Component: Recency
-- Calculating days since last purchase relative to the dataset's final date
SELECT
    CustomerID,
    DATEDIFF('2011-12-09', MAX(InvoiceDate)) AS Recency
FROM online_retail
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID;

-- 3. RFM Component: Frequency & Monetary
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS Frequency,
    SUM(Quantity * UnitPrice) AS Monetary
FROM online_retail
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID; 

-- 4. Market Basket Analysis (Product Pairings)
-- Self-join to identify items frequently purchased together in the same transaction
SELECT
    a.StockCode AS ProductA,
    b.StockCode AS ProductB,
    COUNT(*) AS PairFrequency
FROM online_retail a
JOIN online_retail b ON a.InvoiceNo = b.InvoiceNo
    AND a.StockCode < b.StockCode -- Prevents self-pairing and duplicate A-B/B-A pairs
GROUP BY ProductA, ProductB
ORDER BY PairFrequency DESC;