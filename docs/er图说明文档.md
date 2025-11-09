# 同城配送管理系统 ER 图说明文档

## 一、概述

本系统旨在支持同城配送业务的订单管理、配送追踪、用户管理及接口密钥管理。下文将对系统中的主要实体（表）、属性及实体间关系进行说明，确保数据库设计结构清晰、逻辑完整。

---

## 二、实体与属性说明

### 1. 用户表（`cdms_user`）

| 属性名 | 数据类型 | 是否主键 | 说明 |
|--------|------------|------|------|
| `user_id` | BIGINT | 是    | 用户唯一标识，自增主键 |
| `username` | VARCHAR(50) |      | 用户名（唯一） |
| `password` | VARCHAR(255) |      | 用户密码（加密存储） |
| `role` | TINYINT |      | 用户角色（0=管理员，1=配送员） |
| `phone_no` | VARCHAR(20) |      | 联系电话（配送员手机号） |
| `status` | TINYINT |      | 账号状态（0=启用，1=禁用，2=锁定） |
| `work_status` | TINYINT |      | 工作状态（0=离线，1=在线，2=休息） |
| `fail_count` | INT |      | 连续登录失败次数 |
| `last_login_time` | DATETIME |      | 上次登录时间 |
| `last_login_ip` | VARCHAR(45) |      | 上次登录 IP |
| `last_login_success` | BOOLEAN |      | 上次登录是否成功 |
| `last_login_remark` | VARCHAR(255) |      | 登录备注（如失败原因） |
| `create_time` | DATETIME |      | 创建时间 |
| `creator_id` | BIGINT | FK   | 创建人 ID（外键，关联 `cdms_user.user_id`） |
| `update_time` | DATETIME |      | 更新时间 |
| `profit` | DECIMAL(10,2) |      | 配送员累计收入 |

> **说明：**  
> 管理员可创建配送员账户；配送员可登录系统接单；用户表支持自引用关系，用于记录“创建人”。

---

### 2. 配送订单表（`cdms_delivery_order`）

| 属性名 | 数据类型 | 是否主键 | 说明 |
|--------|------------|------|------|
| `order_id` | VARCHAR(30) | 是    | 订单编号（主键） |
| `sender_name` | VARCHAR(50) |      | 寄件人姓名 |
| `sender_phone` | VARCHAR(20) |      | 寄件人联系电话 |
| `sender_address` | VARCHAR(255) |      | 寄件人地址 |
| `consignee_name` | VARCHAR(50) |      | 收件人姓名 |
| `consignee_phone` | VARCHAR(20) |      | 收件人联系电话 |
| `consignee_address` | VARCHAR(255) |      | 收件人地址 |
| `goods_type` | ENUM('ordinary', 'fragile', 'fresh') |      | 货物类型（普通、易碎、生鲜） |
| `weight` | DECIMAL(10,2) |      | 货物重量（kg） |
| `volume` | DECIMAL(10,3) |      | 货物体积（m³） |
| `delivery_fee` | DECIMAL(10,2) |      | 总配送费用 |
| `platform_income` | DECIMAL(10,2) |      | 平台抽成 |
| `deliveryman_income` | DECIMAL(10,2) |      | 配送员收入 |
| `expected_mins` | INT |      | 预计配送时间（分钟） |
| `remark` | VARCHAR(255) |      | 订单备注 |
| `status` | TINYINT |      | 订单状态（0=待接单，1=已接单，2=配送中，3=已完成，4=已取消，5=放弃待审核） |
| `create_time` | DATETIME |      | 创建时间 |
| `creator_id` | BIGINT | FK   | 创建人 ID（外键，关联管理员用户） |
| `deliveryman_id` | BIGINT | FK   | 配送员 ID（外键，关联用户表） |
| `complete_time` | DATETIME |      | 完成时间 |
| `cancel_time` | DATETIME |      | 取消时间 |
| `abandon_reason` | VARCHAR(100) |      | 放弃原因 |
| `abandon_description` | TEXT |      | 放弃详细说明 |

> **说明：**  
> 每个订单由管理员创建并指派配送员执行。订单状态变化由系统追踪表记录。

---

### 3. 配送追踪表（`cdms_delivery_trace`）

| 属性名 | 数据类型 | 是否主键 | 说明 |
|--------|------------|------|------|
| `trace_id` | BIGINT | 是    | 追踪记录 ID，自增主键 |
| `order_id` | VARCHAR(30) | FK   | 关联订单编号（外键） |
| `status` | TINYINT |      | 对应订单状态 |
| `operator_id` | BIGINT | FK   | 操作者 ID（管理员或配送员） |
| `operate_time` | DATETIME |      | 操作时间 |
| `remark` | VARCHAR(255) |      | 状态变更说明 |

> **说明：**  
> 每条追踪记录对应一次订单状态变更，方便管理员或配送员查看订单历史流转情况。

---

### 4. 第三方接口密钥表（`cdms_api_key`）

| 属性名 | 数据类型 | 是否主键 | 说明 |
|--------|------------|------|------|
| `key_id` | BIGINT | 是    | API 密钥 ID，自增主键 |
| `app_name` | VARCHAR(100) |      | 应用名称 |
| `api_key` | VARCHAR(100) |      | 唯一密钥字符串 |
| `status` | ENUM('enabled','disabled') |      | 密钥状态（启用/禁用） |
| `create_time` | DATETIME |      | 创建时间 |

> **说明：**  
> 第三方系统可使用本表中的 API Key 访问开放接口，便于平台与外部系统集成。

---

## 三、关系说明

| 关系名称 | 关联实体                          | 关系描述 | 基数 |
|-----------|-------------------------------|------------|------|
| 用户创建订单 | `User` → `DeliveryOrder`      | 管理员创建配送订单 | 1 对 多（一个管理员可创建多个订单） |
| 用户接单配送 | `User` → `DeliveryOrder`      | 配送员接收并执行订单 | 1 对 多（一个配送员可执行多个订单） |
| 订单追踪 | `DeliveryOrder` → `DeliveryTrace` | 每个订单包含多条状态追踪记录 | 1 对 多 |
| 追踪操作 | `User` → `DeliveryTrace`      | 管理员或配送员执行状态更新 | 1 对 多 |
| 用户自引用 | `User` → `User`               | 管理员创建其他用户账户 | 1 对 多 |
| 第三方密钥 | `APIKey` 独立存在                 | 与业务表无直接关联 | 单表独立 |

---

## 四、ER 图逻辑关系简述

1. **用户表（User）** 是核心实体，承担两种角色：管理员与配送员。
    - 管理员负责创建账户、发布订单。
    - 配送员负责接单、更新订单状态。

2. **订单表（DeliveryOrder）** 连接用户与配送追踪。
    - `creator_id` → 记录订单的创建者。
    - `deliveryman_id` → 指定订单的配送执行人。

3. **追踪表（DeliveryTrace）** 记录订单的生命周期。
    - 每个订单的每次状态变化由 `operator_id` 指向对应操作者。

4. **API Key 表（APIKey）** 支持系统开放接口访问，是外部系统的认证凭证。

---

## 五、关系说明

| 关系名称   | 关联实体                              | 关系描述           | 基数                  |
| ------ | --------------------------------- | -------------- | ------------------- |
| 用户创建订单 | `User` → `DeliveryOrder`          | 管理员创建配送订单      | 1 对 多（一个管理员可创建多个订单） |
| 用户接单配送 | `User` → `DeliveryOrder`          | 配送员接收并执行订单     | 1 对 多（一个配送员可执行多个订单） |
| 订单追踪   | `DeliveryOrder` → `DeliveryTrace` | 每个订单包含多条状态追踪记录 | 1 对 多               |
| 追踪操作   | `User` → `DeliveryTrace`          | 管理员或配送员执行状态更新  | 1 对 多               |
| 用户自引用  | `User` → `User`                   | 管理员创建其他用户账户    | 1 对 多               |
| 第三方密钥  | `APIKey` 独立存在                     | 与业务表无直接关联      | 单表独立                |


