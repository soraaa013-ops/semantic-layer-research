-- Synthetic fixture. Amounts are integer cents, all in CNY.
-- Fixed snapshot: 2026-10-31. Refunds restate the original sale period.
CREATE TABLE products (sku_id TEXT PRIMARY KEY, model_name TEXT NOT NULL);
CREATE TABLE stores (store_id TEXT PRIMARY KEY, region TEXT NOT NULL);
CREATE TABLE sales (
  sale_line_id TEXT PRIMARY KEY,
  sku_id TEXT NOT NULL REFERENCES products,
  store_id TEXT NOT NULL REFERENCES stores,
  sale_date TEXT NOT NULL,
  amount_cents INTEGER NOT NULL,
  status TEXT NOT NULL
);
CREATE TABLE refunds (
  refund_id TEXT PRIMARY KEY,
  sale_line_id TEXT NOT NULL REFERENCES sales,
  refund_date TEXT NOT NULL,
  amount_cents INTEGER NOT NULL,
  status TEXT NOT NULL
);
INSERT INTO products VALUES ('P1', 'Model-A'), ('P2', 'Model-B');
INSERT INTO stores VALUES ('S1', 'East'), ('S2', 'West');
INSERT INTO sales VALUES
  ('L1', 'P1', 'S1', '2026-09-10', 20000, 'completed'),
  ('L2', 'P2', 'S1', '2026-09-11', 30000, 'completed'),
  ('L3', 'P1', 'S2', '2026-09-12', 12000, 'completed'),
  ('L4', 'P1', 'S1', '2026-09-13', 90000, 'cancelled');
INSERT INTO refunds VALUES
  ('R1', 'L1', '2026-09-11', 1000, 'completed'),
  ('R2', 'L1', '2026-10-02', 2000, 'completed'),
  ('R3', 'L2', '2026-10-03', 5000, 'pending'),
  ('R4', 'L2', '2026-11-01', 6000, 'completed');

CREATE VIEW mart_sale_line AS
WITH refund_by_line AS (
  SELECT sale_line_id, SUM(amount_cents) AS refund_cents
  FROM refunds
  WHERE status = 'completed' AND refund_date <= '2026-10-31'
  GROUP BY sale_line_id
)
SELECT s.sale_line_id, s.sale_date, p.model_name, t.region,
       s.amount_cents AS gross_amount_cents,
       COALESCE(r.refund_cents, 0) AS refund_amount_cents,
       s.amount_cents - COALESCE(r.refund_cents, 0) AS net_amount_cents
FROM sales AS s
JOIN products AS p ON p.sku_id = s.sku_id
JOIN stores AS t ON t.store_id = s.store_id
LEFT JOIN refund_by_line AS r ON r.sale_line_id = s.sale_line_id
WHERE s.status = 'completed' AND s.sale_date <= '2026-10-31';
