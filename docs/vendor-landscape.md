# 企业内部数据语义层：厂商方案深度调研

资料核查日期：2026-11-12。下文“构建与设计”基于所附官方资料；“架构判断”是本仓库的分析，不代表厂商承诺或实际部署结果。

若需要先理解 IT 团队实际要做哪些工作、产品里创建什么、业务如何消费，请先阅读 [终端 IT 完整建设案例](terminal-it-walkthrough.md)，再用本文比较方案。

## 1. 比较之前：明确语义层的责任

一套可供企业使用的语义层通常需要回答：业务概念对应什么数据；指标如何计算；数据按什么粒度关联；时间和历史状态如何解释；谁能访问；消费者通过什么接口使用。

业务词典解决命名与说明，目录帮助发现和治理，查询引擎执行计算，业务本体还可能定义对象和行为。它们可以组合，但不能用一个产品名称抹平责任差异。

| 方案 | 核心交付物 | 主要消费场景 | 关键架构选择 |
| --- | --- | --- | --- |
| Looker | LookML、Explore、SQL 生成 | 自助分析与共享报表 | 预先组织可查询范围和关联 |
| Power BI / Fabric | 表格模型、DAX、分析引擎 | 报表、Excel、交互分析 | 计算上下文与存储模式共同支撑模型 |
| dbt Semantic Layer | 语义模型、指标、MetricFlow | 跨工具指标复用 | 按实体关系规划查询 |
| Cube | 模型、API、权限、缓存 | 多 BI、自研应用、嵌入分析 | 独立在线语义服务 |
| AtScale | 多维模型、查询适配、自动聚合 | Excel、多 BI、大规模分析 | 多维消费与聚合管理 |
| Snowflake | Semantic Views | SQL、Cortex 分析与 Agent | schema 级原生语义对象 |
| Databricks | Unity Catalog Metric Views | 仪表盘、Notebook、Genie | 目录治理与指标求值 |
| Denodo | 规范业务实体、虚拟视图 | 分散数据源统一访问 | 逻辑接口与源系统解耦 |
| SuperSonic | Headless BI 与 Chat BI | 企业自然语言问数 | 语义查询中间层 |
| Palantir | 对象、关系、函数、动作 | 运营决策与业务执行 | 数据、逻辑、行为和权限整合 |

## 2. Google Looker

**构建了什么。** View 定义维度与度量，Model 组织连接与模型，Explore 定义可探索的数据及关联。业务用户选字段、分组和过滤，Looker 据此生成 SQL。LookML 项目进入 Git 管理。[LookML 概念](https://docs.cloud.google.com/looker/docs/lookml-terms-and-concepts)

**供给什么场景。** 分析师提前建模，销售、运营等业务用户自行探索；多份报表共享相同定义。与让用户自由连接物理表相比，这一方式更强调分析边界的可管理性。

**为此做的设计。** Explore 把可用字段和关系组织成业务入口。对称聚合处理关联导致的重复计数：订单连接到多条明细后，订单级金额仍应按订单正确计入。实现依赖真实唯一主键、正确的关联关系和数据库支持。[关联与主键](https://docs.cloud.google.com/looker/docs/working-with-joins?hl=en)、[对称聚合](https://docs.cloud.google.com/looker/docs/best-practices/understanding-symmetric-aggregates)

**架构判断。** 核心价值是将分析师掌握的正确查询方式固化为可执行模型。适合受治理的自助分析；需要持续维护模型和主键质量。外部应用必须通过实际支持的消费路径使用这些定义，才有一致性。

**验收重点。** 订单—订单明细—退款组合后金额是否正确；新增 Explore 是否重复定义指标；模型修改是否破坏已有内容。

## 3. Microsoft Power BI / Fabric

**构建了什么。** 语义模型组织表、关系和 DAX 度量值。度量随筛选、分组与关系传播求值。模型因此既描述数据，也定义交互分析的计算行为。[星型模型](https://learn.microsoft.com/en-us/power-bi/guidance/star-schema/)、[DAX 上下文](https://learn.microsoft.com/en-us/power-bi/transform-model/desktop-quickstart-learn-dax-basics)

**供给什么场景。** 企业报表、经营驾驶舱、Excel 分析，以及大量用户在相同模型上钻取、切片和对比。

**为此做的设计。** 毛利率可以定义为当前筛选范围的毛利合计除以收入合计，避免简单平均行级比例。数据访问有 Import、DirectQuery、Direct Lake 等模式。Direct Lake 将 OneLake Delta 表的数据按需加载入内存；on OneLake 与 on SQL 的能力和回退行为不同。[Direct Lake](https://learn.microsoft.com/en-us/fabric/fundamentals/direct-lake-overview)

RLS 将角色与行过滤纳入执行。它不限制工作区 Admin、Member、Contributor，需按消费者实际身份测试。[RLS](https://learn.microsoft.com/en-us/fabric/security/service-admin-row-level-security)

**架构判断。** 适合微软分析生态和复杂交互计算。跨工具使用必须检查语义协议，而不仅检查数据库连接。微软明确指出叠加第三方语义层可能导致错误计算。[第三方兼容边界](https://learn.microsoft.com/en-us/power-bi/connect-data/semantic-models-third-party)

**验收重点。** 比率与总计、非活动关系、动态权限、不同存储模式，以及外部工具是否再次错误聚合。

## 4. dbt Semantic Layer / MetricFlow

**构建了什么。** 在 dbt 工程中集中定义语义模型和指标，MetricFlow 规划 SQL，服务层提供下游访问。官方将模型与 SQL 生成能力同托管服务、API 和集成分开列示。[产品概览](https://docs.getdbt.com/docs/use-dbt-semantic-layer/dbt-sl)、[组件架构](https://docs.getdbt.com/docs/use-dbt-semantic-layer/sl-architecture)

**供给什么场景。** 数据团队已经使用 dbt，不同业务单位又使用不同 BI，希望迁移散落在消费端的指标定义。

**为此做的设计。** 通过 primary、foreign、unique 等实体类型描述模型关系，MetricFlow 根据实体与请求判断关联，限制易产生 fanout、chasm join 的路径。查询者表达指标、维度、时间范围，而不是每次手写完整关联。[MetricFlow](https://docs.getdbt.com/docs/build/about-metricflow?version=2)

**架构判断。** 它把指标当作工程资产，并让查询逻辑从资产生成。适合分析工程团队主导治理。实体图存在可表达边界，复杂多对多、特殊时间逻辑应逐项验证。自建 SQL 生成器不等于已经具备完整托管产品的接口、身份与运维能力。

**验收重点。** 核心指标跨工具是否一致；不可规划的维度组合是否明确拒绝；部署版本、缓存和导出是否同步更新。

## 5. Cube

**构建了什么。** Cube 模型包含度量、维度、关联、预聚合与访问策略，通过 Views 组织消费者看到的内容，并提供 SQL、REST、GraphQL 等接口。[模型结构](https://docs.cube.dev/reference/data-modeling/cube)、[模型与接口](https://cube.dev/product/data-modeling)

**供给什么场景。** 内部看板、业务系统、自研前端、客户分析门户和 AI 需要同一套数据服务。

**为此做的设计。** 将模型与展示界面分离；预聚合与缓存减少反复扫描明细；访问控制限制可见模型成员和数据，支持多租户应用。[缓存机制](https://cube.dev/product/caching-and-data-performance)、[访问控制](https://cube.dev/product/data-access-control)

**架构判断。** Cube 的重心是独立在线服务。例如客户门户调用“按月净收入”，服务同时处理租户限制、指标计算和查询加速。企业需要运营缓存刷新、预聚合构建、并发及可用性。不同部署和产品版本的能力仍需分别核实。

**验收重点。** 缓存是否按授权上下文隔离；预聚合是否覆盖真实负载；实时性与成本能否同时满足要求。

## 6. AtScale

**构建了什么。** 多维模型包含维度、层级和度量，可服务 SQL、MDX 查询。层级表示年—季度—月、国家—省—市等分析结构。[维度建模](https://documentation.atscale.com/container/creating-and-sharing-cubes/creating-cubes/modeling-cube-dimensions/add-dimensions-to-projects-and-cubes/add-a-normal-dimension)、[查询引擎](https://documentation.atscale.com/installer/I2025.1.0/provisioning-with-the-orchestrator/query-engine)

**供给什么场景。** 大量 Excel、多维分析习惯和多个 BI 共存，数据规模较大，希望共享模型并控制交互延迟。

**为此做的设计。** 根据查询负载和模型元数据自动创建、调整聚合表，区分聚合定义与物化实例，同时允许手动定义聚合。这将原本需要团队持续维护的汇总表优化，部分转为系统任务。[聚合机制](https://documentation.atscale.com/installer/I2025.4.x/managing-atscale/managing-aggregates/about-aggregates)

**架构判断。** 适合把多维兼容性和查询性能放在首位的企业。自动化并不消除刷新、存储与计算成本。本文引用的部分架构资料属于特定安装版，不代表所有版本的发布状态和扩展限制。

**验收重点。** 层级、总计、去重和半可加指标；负载变化后的聚合收益；新增聚合与数据更新成本。

## 7. Snowflake Semantic Views

**构建了什么。** Semantic View 是 schema 级对象，描述逻辑表、关系、维度、事实与指标，可通过 SQL 或 YAML 等方式管理，并服务 SQL 和 Cortex。[官方概览](https://docs.snowflake.com/en/user-guide/views-semantic/overview)

**供给什么场景。** 数据集中于 Snowflake，希望分析、BI 与自然语言问数共享定义，并沿用平台对象治理。

**为此做的设计。** 区分行级事实与聚合指标；通过 Verified Queries 保存经验证的问题与 SQL；支持对问数效果进行评估，评估使用的示例会从临时视图中移除，避免同一条示例同时充当提示与测试答案。[验证查询](https://docs.snowflake.com/en/user-guide/views-semantic/sql)、[评估机制](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst-evaluations)

**架构判断。** 原生对象有利于平台内整合，但“引用语义”与“强制按语义执行”需分别确认。当前概览描述 Cortex Agents 读取定义后可以直接生成针对物理表的 SQL，不能假设所有 AI 查询都经过同一指标编译路径。

**验收重点。** AI 是否正确使用业务定义；生成 SQL 是否遵守授权；物理表查询与语义视图查询是否一致；多义问题是否澄清。

## 8. Databricks Metric Views

**构建了什么。** Metric Views 以 YAML 等方式定义维度与度量，注册到 Unity Catalog，供 SQL、仪表盘、Notebook、Genie 等使用。[视图概览](https://docs.databricks.com/aws/en/views)、[目录与权限](https://docs.databricks.com/aws/en/uc-semantics/metric-views/manage)

**供给什么场景。** 同一湖仓平台中的工程、分析、数据科学和 AI 团队需要共同使用指标。

**为此做的设计。** 查询通过 `MEASURE()` 求值，明确区分度量和普通数值列；模型还可包含面向消费端的名称、同义词、格式等信息。[查询机制](https://docs.databricks.com/aws/en/uc-semantics/metric-views/query)

例如以下是说明性 SQL，须替换为实际视图和字段：

```sql
SELECT region, MEASURE(total_revenue)
FROM sales_metrics
GROUP BY region;
```

**架构判断。** 目录、计算与指标在同一平台内协同。关联类型、物化、BI 兼容等功能有版本要求；JDBC/ODBC 能连接不意味着客户端完整理解度量语义。[版本矩阵](https://docs.databricks.com/aws/en/uc-semantics/metric-views/feature-availability)

**验收重点。** 实际运行时版本、外部 BI 再聚合、窗口与非可加指标、模型权限和底层权限的组合。

## 9. Denodo

**构建了什么。** 官方实践使用基础、集成、语义、业务建模和应用等层次，语义层包含可复用的规范业务实体，消费者通过视图访问。[分层模型](https://community.denodo.com/kb/en/view/document/Fine-grained%20privileges%20and%20caching%20best%20practices)

**供给什么场景。** ERP、CRM、遗留数据库和多云数据分散，难以先完成物理整合，需要统一客户、合同等业务对象的访问。

**为此做的设计。** 源系统细节与面向业务的接口分离。域团队维护内部集成视图，发布接口视图作为数据产品，减小源系统变化的影响。系统也支持缓存，因此虚拟化不等于完全不持有数据副本。[域与接口视图](https://community.denodo.com/kb/en/view/document/Denodo%20Design%20Guidelines%20for%20Data%20Mesh%20and%20Decentralized%20Data%20Organizations)、[缓存实践](https://community.denodo.com/kb/en/view/document/Best%20Practices%20to%20Maximize%20Performance%20III%3A%20Caching?tag=Best+Practices)

**架构判断。** 主要价值偏向跨源业务整合。客户实体的统一视图仍依赖实体匹配和源数据质量；复杂指标的聚合与时间行为需要单独验收。

**验收重点。** 跨源性能、数据新鲜度、源故障影响、身份映射，以及实体统一后的历史状态处理。

## 10. 腾讯音乐 SuperSonic

**构建了什么。** 开源 AI+BI 框架，把 Chat BI 与 Headless BI 结合：先建立指标、维度等语义模型，再供自然语言查询使用。[官方项目](https://github.com/tencentmusic/supersonic)

**供给什么场景。** 企业自建问数系统，希望掌握模型、查询流程和业务扩展。

**为此做的设计。** 通过语义知识检索、Schema 映射、解析、校正和翻译形成查询链路；语言模型与规则识别业务意图，语义层承担复杂关联和公式的物理 SQL 生成。项目列出了数据集、列、行三级权限。[官方架构说明](https://github.com/tencentmusic/supersonic)

**架构判断。** 自然语言和 SQL 之间的语义表示，使错误可以分解为业务映射错误、查询结构错误和执行错误，便于调试。企业仍需承担适配、部署和评测责任。

**验收重点。** 中文业务词、同义词、维度值、多轮上下文、歧义澄清，以及不同身份的查询结果。

## 11. Palantir Ontology

**构建了什么。** 对象、属性和关系表达业务实体，Actions 与 Functions 表达可执行行为与逻辑。[Ontology](https://www.palantir.com/docs/foundry/ontology)

**供给什么场景。** 运营人员发现交付风险后继续调整库存、安排资源或创建工单，AI 与人协作完成业务闭环。

**为此做的设计。** 元数据之外，还有对象存储、查询服务、动作处理与数据更新等后端机制。系统关注具体订单、设备的状态以及允许执行的变化。[后端架构](https://www.palantir.com/docs/foundry/object-backend/overview)

**架构判断。** Palantir 当前文档强调 Ontology 超出薄语义层，整合数据、逻辑、动作和安全；应作为业务操作架构比较，不能直接等同于指标服务。[系统定位](https://www.palantir.com/docs/foundry/architecture-center/ontology-system)

**验收重点。** 对象身份、状态更新、动作权限、业务系统写回和失败恢复。若仅需统一经营报表，这些能力可能超过首期建设范围。

## 12. 同一业务问题下的比较

例：“上季度华东大客户净收入为何下降，哪些客户需要跟进？”

| 必须明确的事项 | 失败方式 | 需要的能力 |
| --- | --- | --- |
| 净收入是否扣退款和税 | 各报表都能算，但口径不同 | 指标契约 |
| 按付款日还是确认日 | 时间窗口相同，业务含义不同 | 时间语义 |
| 大客户按历史还是当前等级 | 历史重算后结果漂移 | 版本与历史维度 |
| 一单多笔退款 | 关联后重复累计订单金额 | 粒度和关联规划 |
| 谁可看哪些客户 | 查询正确但越权 | 授权执行 |
| 哪些因素贡献了变化 | 描述相关性却声称因果 | 分析方法与证据 |
| 能否创建跟进任务 | 将建议误认为已完成操作 | 对象与动作接口 |

统一语义能减少分析中的口径漂移，但不能自动证明因果，也不能自动完成写回。模型侧的分析能力另见 [DeepAnalyze 专题](deepanalyze.md)，组合方式见 [参考架构](architecture-and-selection.md)。
