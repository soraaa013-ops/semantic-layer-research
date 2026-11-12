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

## Ossie 语义文件

[terminal-sales.ossie.json](terminal-sales.ossie.json) 使用 Apache Ossie `0.3.0.dev0` 草案描述上述视图及指标，供阅读和结构验证。字段和公式对应本例，未实现自动消费该文件的查询引擎。

2026-11-12 已通过固定提交 `e6ad94ee87a53fd8f8b6dbf0de33fab59e406c0c` 的官方 JSON Schema 校验。Schema SHA-256 为 `4e96fb63c3f3fcc8040b627707df7f3d6b00f45ca0316bd1c7c7ce966ddc9b3f`。草案未发布，不应作为投产兼容性承诺。

在已安装 `jsonschema` 的 Python 环境、仓库根目录中可复核：

```python
import json
import urllib.request
from pathlib import Path
import jsonschema

url = (
    "https://raw.githubusercontent.com/apache/ossie/"
    "e6ad94ee87a53fd8f8b6dbf0de33fab59e406c0c/core-spec/ossie-schema.json"
)
with urllib.request.urlopen(url, timeout=20) as response:
    schema = json.load(response)
model = json.loads(Path("examples/terminal-sales/terminal-sales.ossie.json").read_text())
jsonschema.validate(model, schema)
```

校验不执行表达式，不认证权限、跨厂商兼容性或业务正确性。标准在 Agent 服务中的位置见 [Agent 数据服务与 Ossie](../../docs/agent-data-and-ossie.md)。
