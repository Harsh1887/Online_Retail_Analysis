-- Create a View for analysis to preserve the original table while adding insights
SELECT
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country,
    -- Calculation of total revenue per line item
    Quantity * UnitPrice AS Revenue,
    -- Categorizing transactions to separate returns from sales
    CASE 
        WHEN Quantity < 0 THEN 'Refund'
        ELSE 'Sale'
    END AS TransactionType,
    -- Classifying customer types for segmentation
    CASE
        WHEN CustomerID IS NULL THEN 'Anonymous'
        ELSE 'Registered'
    END AS CustomerType,
    -- Identifying pricing exceptions
    CASE
        WHEN UnitPrice = 0 THEN 'FreeItem'
        ELSE 'PaidItem'
    END AS PriceType
FROM online_retail;

-- Verify View
SELECT * FROM online_retail WHERE CustomerID IS NOT NULL LIMIT 10;