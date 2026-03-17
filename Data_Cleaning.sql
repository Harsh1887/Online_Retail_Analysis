-- 1. Initial Table Maintenance
USE online_retail;

-- Rename corrupted column name if necessary
ALTER TABLE online_retail RENAME COLUMN `ï»¿InvoiceNo` TO InvoiceNo;

-- 2. Data Sanitization for UnitPrice
-- Disabling safe updates to allow mass cleaning of string characters
SET SQL_SAFE_UPDATES = 0;

UPDATE online_retail SET UnitPrice = REPLACE(UnitPrice, '$', '');
UPDATE online_retail SET UnitPrice = TRIM(UnitPrice);
UPDATE online_retail SET UnitPrice = REPLACE(UnitPrice, '(', '');
UPDATE online_retail SET UnitPrice = REPLACE(UnitPrice, ')', '');
UPDATE online_retail SET UnitPrice = REPLACE(UnitPrice, ',', '');
	

-- 3. Data Type Transformation
-- Converting UnitPrice from Text to Decimal for mathematical calculations
ALTER TABLE online_retail
MODIFY UnitPrice DECIMAL(10,2);

-- Verify cleaning
SELECT SUM(Quantity * UnitPrice) AS TotalRevenue FROM online_retail;