# 来源索引与研究方法

资料核查日期：2026-11-12。

## 证据分级

| 类型 | 本仓库如何使用 |
| --- | --- |
| 官方产品文档 | 描述已公开机制；注意版本、地区、商业版与预览状态 |
| 作者论文 | 标注论文版本和作者报告值，不视为独立复测 |
| 模型卡 / 数据卡 | 确认发布入口与许可证声明，不推定全部衍生材料同一许可 |
| 固定版本源码 | 核查具体实现，不外推为所有入口或后续版本的行为 |
| 本仓库分析 | 明确写为架构判断、候选路线、参考设计或评测计划 |

没有进行厂商部署、模型推理、性能复现、报价或采购资格认证。外部链接的可访问性不等同于技术结论得到实测验证。

## DeepAnalyze 版本基线

- 实现核查：`ruc-datalab/DeepAnalyze` 提交 `afc697a11675c59683b9f6596c3ab3b3d661182a`。
- 具体论文分数：arXiv `2510.16872v1`，2025-10-19；采用其 Table 1、2、3。
- PMLR 2026 页面：仅确认后续发表记录，未与 v1 数值混用。
- 模型卡、数据卡和 EvoOntology：查询当日公开页面；后续内容可能变化。
- 基础推理源码观察与 DA-Studio 文档陈述分开记录，未做沙箱运行验证。

## 引用原则

正文在相关陈述处直接引用，下表便于集中复核。尽量使用第一方来源；本仓库不转载完整论文、厂商文档或第三方代码。表格、架构建议和验收样例为原创整理。

## 厂商资料

| 来源 | 链接 | 核查日期 |
| --- | --- | --- |
| LookML 概念 | [原始来源](https://docs.cloud.google.com/looker/docs/lookml-terms-and-concepts) | 2026-11-12 |
| 关联与主键 | [原始来源](https://docs.cloud.google.com/looker/docs/working-with-joins?hl=en) | 2026-11-12 |
| 对称聚合 | [原始来源](https://docs.cloud.google.com/looker/docs/best-practices/understanding-symmetric-aggregates) | 2026-11-12 |
| 星型模型 | [原始来源](https://learn.microsoft.com/en-us/power-bi/guidance/star-schema/) | 2026-11-12 |
| DAX 上下文 | [原始来源](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-quickstart-learn-dax-basics) | 2026-11-12 |
| Direct Lake | [原始来源](https://learn.microsoft.com/en-us/fabric/fundamentals/direct-lake-overview) | 2026-11-12 |
| RLS | [原始来源](https://learn.microsoft.com/en-us/fabric/security/service-admin-row-level-security) | 2026-11-12 |
| 第三方兼容边界 | [原始来源](https://learn.microsoft.com/en-us/power-bi/connect-data/semantic-models-third-party) | 2026-11-12 |
| 产品概览 | [原始来源](https://docs.getdbt.com/docs/use-dbt-semantic-layer/dbt-sl) | 2026-11-12 |
| 组件架构 | [原始来源](https://docs.getdbt.com/docs/use-dbt-semantic-layer/sl-architecture) | 2026-11-12 |
| MetricFlow | [原始来源](https://docs.getdbt.com/docs/build/about-metricflow?version=2) | 2026-11-12 |
| 模型结构 | [原始来源](https://docs.cube.dev/reference/data-modeling/cube) | 2026-11-12 |
| 模型与接口 | [原始来源](https://cube.dev/product/data-modeling) | 2026-11-12 |
| 缓存机制 | [原始来源](https://cube.dev/product/caching-and-data-performance) | 2026-11-12 |
| 访问控制 | [原始来源](https://cube.dev/product/data-access-control) | 2026-11-12 |
| 维度建模 | [原始来源](https://documentation.atscale.com/container/creating-and-sharing-cubes/creating-cubes/modeling-cube-dimensions/add-dimensions-to-projects-and-cubes/add-a-normal-dimension) | 2026-11-12 |
| 查询引擎 | [原始来源](https://documentation.atscale.com/installer/I2025.1.0/provisioning-with-the-orchestrator/query-engine) | 2026-11-12 |
| 聚合机制 | [原始来源](https://documentation.atscale.com/installer/I2025.4.x/managing-atscale/managing-aggregates/about-aggregates) | 2026-11-12 |
| 官方概览 | [原始来源](https://docs.snowflake.com/en/user-guide/views-semantic/overview) | 2026-11-12 |
| 验证查询 | [原始来源](https://docs.snowflake.com/en/user-guide/views-semantic/sql) | 2026-11-12 |
| 评估机制 | [原始来源](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst-evaluations) | 2026-11-12 |
| 视图概览 | [原始来源](https://docs.databricks.com/aws/en/views) | 2026-11-12 |
| 目录与权限 | [原始来源](https://docs.databricks.com/aws/en/uc-semantics/metric-views/manage) | 2026-11-12 |
| 查询机制 | [原始来源](https://docs.databricks.com/aws/en/uc-semantics/metric-views/query) | 2026-11-12 |
| 版本矩阵 | [原始来源](https://docs.databricks.com/aws/en/uc-semantics/metric-views/feature-availability) | 2026-11-12 |
| 分层模型 | [原始来源](https://community.denodo.com/kb/en/view/document/Fine-grained%20privileges%20and%20caching%20best%20practices) | 2026-11-12 |
| 域与接口视图 | [原始来源](https://community.denodo.com/kb/en/view/document/Denodo%20Design%20Guidelines%20for%20Data%20Mesh%20and%20Decentralized%20Data%20Organizations) | 2026-11-12 |
| 缓存实践 | [原始来源](https://community.denodo.com/kb/en/view/document/Best%20Practices%20to%20Maximize%20Performance%20III%3A%20Caching?tag=Best+Practices) | 2026-11-12 |
| 官方项目 | [原始来源](https://github.com/tencentmusic/supersonic) | 2026-11-12 |
| Ontology | [原始来源](https://www.palantir.com/docs/foundry/ontology) | 2026-11-12 |
| 后端架构 | [原始来源](https://www.palantir.com/docs/foundry/object-backend/overview) | 2026-11-12 |
| 系统定位 | [原始来源](https://www.palantir.com/docs/foundry/architecture-center/ontology-system) | 2026-11-12 |

## DeepAnalyze 与关联项目

| 来源 | 链接 | 核查日期 |
| --- | --- | --- |
| 项目主页 | [原始来源](https://ruc-deepanalyze.github.io/) | 2026-11-12 |
| 模型卡 | [原始来源](https://huggingface.co/RUC-DataLab/DeepAnalyze-8B) | 2026-11-12 |
| 数据卡 | [原始来源](https://huggingface.co/datasets/RUC-DataLab/DataScience-Instruct-500K) | 2026-11-12 |
| 固定版本仓库 | [原始来源](https://github.com/ruc-datalab/DeepAnalyze/tree/afc697a11675c59683b9f6596c3ab3b3d661182a) | 2026-11-12 |
| 固定版本说明 | [原始来源](https://github.com/ruc-datalab/DeepAnalyze/blob/afc697a11675c59683b9f6596c3ab3b3d661182a/demo/chat_v2/README.md) | 2026-11-12 |
| 原始论文 | [原始来源](https://arxiv.org/abs/2510.16872v1) | 2026-11-12 |
| PMLR 记录 | [原始来源](https://proceedings.mlr.press/v306/zhang26aq.html) | 2026-11-12 |
| 固定版本开发说明 | [原始来源](https://github.com/ruc-datalab/DeepAnalyze/blob/afc697a11675c59683b9f6596c3ab3b3d661182a/README.md) | 2026-11-12 |
| add_vocab.py | [原始来源](https://github.com/ruc-datalab/DeepAnalyze/blob/afc697a11675c59683b9f6596c3ab3b3d661182a/deepanalyze/add_vocab.py) | 2026-11-12 |
| 运行器 | [原始来源](https://github.com/ruc-datalab/DeepAnalyze/blob/afc697a11675c59683b9f6596c3ab3b3d661182a/deepanalyze.py) | 2026-11-12 |
| 论文第 3 节 | [原始来源](https://arxiv.org/html/2510.16872v1) | 2026-11-12 |
| single.sh | [原始来源](https://github.com/ruc-datalab/DeepAnalyze/blob/afc697a11675c59683b9f6596c3ab3b3d661182a/scripts/single.sh) | 2026-11-12 |
| multi_coldstart.sh | [原始来源](https://github.com/ruc-datalab/DeepAnalyze/blob/afc697a11675c59683b9f6596c3ab3b3d661182a/scripts/multi_coldstart.sh) | 2026-11-12 |
| multi_rl.sh | [原始来源](https://github.com/ruc-datalab/DeepAnalyze/blob/afc697a11675c59683b9f6596c3ab3b3d661182a/scripts/multi_rl.sh) | 2026-11-12 |
| 官方仓库 | [原始来源](https://github.com/ruc-datalab/EvoOntology) | 2026-11-12 |

## 后续更新

产品行为变化时更新正文对应结论及核查日期；源码观察保留原提交以便回溯。增加独立实测结果时，附数据、配置、评价方法和可复现产物。不要以新版本文档替换旧实验的运行条件。
