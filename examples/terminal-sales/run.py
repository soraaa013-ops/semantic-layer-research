"""Run the synthetic data-preparation example with Python's standard library."""

from pathlib import Path
import sqlite3


def main():
    with sqlite3.connect(":memory:") as db:
        db.execute("PRAGMA foreign_keys = ON")
        db.executescript(Path(__file__).with_name("model.sql").read_text())
        rows = db.execute(
            "SELECT region, model_name, SUM(net_amount_cents) "
            "FROM mart_sale_line GROUP BY region, model_name "
            "ORDER BY region, model_name"
        ).fetchall()
        expected = [("East", "Model-A", 17000),
                    ("East", "Model-B", 30000),
                    ("West", "Model-A", 12000)]
        if rows != expected:
            raise AssertionError(f"Contract mismatch: {rows!r}")

        # Deliberately incorrect: demonstrates fanout with otherwise same filters.
        wrong = db.execute("""
            SELECT SUM(s.amount_cents - COALESCE(r.amount_cents, 0))
            FROM sales AS s LEFT JOIN refunds AS r
              ON r.sale_line_id = s.sale_line_id
              AND r.status = 'completed' AND r.refund_date <= '2026-10-31'
            WHERE s.status = 'completed' AND s.sale_date <= '2026-10-31'
        """).fetchone()[0]
        if wrong != 79000:
            raise AssertionError(f"Unexpected fanout example result: {wrong}")

        print("Snapshot: 2026-10-31; refunds restate the original sale period")
        for region, model, cents in rows:
            print(f"{region:5} | {model:7} | CNY {cents / 100:.2f}")
        print(f"Company total: CNY {sum(row[2] for row in rows) / 100:.2f}")
        print(f"Incorrect direct join: CNY {wrong / 100:.2f}")
        print("PASS: fanout, status filters, and snapshot cutoff match the fixture contract")


if __name__ == "__main__":
    main()
