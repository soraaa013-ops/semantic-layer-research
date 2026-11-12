# 终端销售：从应用数据到可建模的数据集

所有记录均为虚构，不代表任何企业真实系统。此示例演示建语义层之前和过程中需要做的数据对齐与口径计算，使用 Python 标准库和内存 SQLite。

在仓库根目录运行：

```bash
python examples/terminal-sales/run.py
```

预期输出：

```text
Snapshot: 2026-10-31; refunds restate the original sale period
East  | Model-A | CNY 170.00
East  | Model-B | CNY 300.00
West  | Model-A | CNY 120.00
Company total: CNY 590.00
Incorrect direct join: CNY 790.00
PASS: fanout, status filters, and snapshot cutoff match the fixture contract
```

[model.sql](model.sql) 建立销售、退款、商品、门店四张表及 `mart_sale_line` 视图；[run.py](run.py) 检查结果并演示错误关联。

口径固定为：人民币整数分；已完成销售；已成功退款；截至 2026-10-31；退款回溯原销售期间。门店归属不随时间变化，退款已关联到原订单行；这些是示例前提，不是自动解决的业务问题。

该视图可以作为 [厂商建模案例](../../docs/terminal-it-walkthrough.md) 的输入。它不提供登录、RLS、API、实时同步或生产级语义查询编译，也不代表 Looker、Power BI 或 Snowflake 已通过测试。
