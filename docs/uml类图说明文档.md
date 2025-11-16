---
title: |
   \begin{center}
   \textbf{同城配送管理系统}\\
   \textbf{UML类图说明文档}
   \end{center}
date: "2025年11月"

# 页面排版
fontsize: 12pt
geometry: margin=2.5cm
linestretch: 1.5

# 目录设置
toc: true
toc-depth: 3

# 超链接颜色
colorlinks: true
linkcolor: blue

# LaTeX 宏包与设置
header-includes:
  - \input{fontsetup.tex}
---

\newpage

[//]: # (# UML 类图说明文档)

## 一、系统概述

本系统为**同城配送管理系统**的核心类图，描述了用户（管理员与配送员）、订单、配送轨迹以及系统 API 密钥等核心实体及其关系。  
主要功能包括：下单、配送、追踪、用户登录管理等。

## 二、类说明

### 1. 抽象类 `User`

| 属性名              | 类型       | 说明                        |
| :--------------- | :------- | :------------------------ |
| userId           | Long     | 用户唯一标识                    |
| username         | String   | 用户名                       |
| password         | String   | 密码（加密存储）                  |
| role             | int      | 用户角色（0=普通用户，1=配送员，2=管理员）  |
| phoneNo          | String   | 联系电话                      |
| status           | int      | 账号状态（0=禁用，1=启用）           |
| workStatus       | int      | 工作状态（对配送员有效，如：0=空闲，1=配送中） |
| failCount        | int      | 登录失败次数                    |
| lastLoginTime    | DateTime | 上次登录时间                    |
| lastLoginIp      | String   | 上次登录 IP                   |
| lastLoginSuccess | Boolean  | 上次登录是否成功                  |
| lastLoginRemark  | String   | 登录备注信息                    |
| createTime       | DateTime | 创建时间                      |
| updateTime       | DateTime | 更新时间                      |

**说明：**

User 为系统的抽象父类，不直接实例化，由 CommonUser 和 Deliveryman 继承。

### 2. 类 `CommonUser`

- 继承自：User
- 描述：系统的普通下单用户，可以创建配送订单。

**主要职责：**

- 下单（创建 DeliveryOrder）
- 查询订单状态与历史记录

**关联关系：**

- `CommonUser 1 → 0..* DeliveryOrder`：一个用户可以创建多个订单。

### 3. 类 `Deliveryman`

- 继承自：User
- 描述：系统中的配送员，负责接单和配送。

**主要职责：**

- 接受并执行配送任务（DeliveryOrder）
- 更新订单的配送轨迹（DeliveryTrace）

**关联关系：**

- `Deliveryman 1 → 0..* DeliveryOrder`：一个配送员可配送多个订单。

### 4. 类 `DeliveryOrder`

| 属性名              | 类型       | 说明                          |
| :--------------- | :------- | :-------------------------- |
| orderId          | String   | 订单编号                        |
| senderName       | String   | 寄件人姓名                       |
| senderPhone      | String   | 寄件人电话                       |
| senderAddress    | String   | 寄件地址                        |
| consigneeName    | String   | 收件人姓名                       |
| consigneePhone   | String   | 收件人电话                       |
| consigneeAddress | String   | 收件地址                        |
| goodsType        | String   | 货物类型                        |
| weight           | Decimal  | 重量（kg）                      |
| volume           | Decimal  | 体积（m³）                      |
| deliveryFee      | Decimal  | 配送费用                        |
| expectedHours    | int      | 预计送达时间（小时）                  |
| remark           | String   | 备注                          |
| status           | int      | 状态（0=待接单，1=配送中，2=已完成，3=已取消） |
| createTime       | DateTime | 下单时间                        |
| completeTime     | DateTime | 完成时间                        |
| cancelTime       | DateTime | 取消时间                        |

**关联关系：**

- `DeliveryOrder 1 → 0..* DeliveryTrace`：一个订单有多条配送轨迹。
- 由 `CommonUser` 创建。
- 由 `Deliveryman` 执行。

### 5. 类 `DeliveryTrace`

| 属性名         | 类型       | 说明                    |
| :---------- | :------- | :-------------------- |
| traceId     | Long     | 轨迹编号                  |
| status      | int      | 当前配送状态（如：揽件中、运输中、已签收） |
| operateTime | DateTime | 操作时间                  |
| remark      | String   | 备注信息                  |

关联关系：

- 属于某个 `DeliveryOrder`。
- 由 `User`（包括配送员或系统管理员）操作生成。

### 6. 类 `ApiKey`

| 属性名        | 类型       | 说明        |
| :--------- | :------- | :-------- |
| keyId      | Long     | 主键 ID     |
| appName    | String   | 应用名称      |
| apiKey     | String   | 访问密钥      |
| status     | String   | 状态（启用/禁用） |
| createTime | DateTime | 创建时间      |

**说明：**

- `ApiKey` 用于系统API接口调用验证，确保外部系统访问安全。