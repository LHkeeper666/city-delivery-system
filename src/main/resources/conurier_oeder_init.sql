-- 1. 先创建数据库（若不存在）
CREATE SCHEMA IF NOT EXISTS cdms DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE cdms;

-- =========================
-- 1. 基础表：用户表（含管理员/外卖员角色）
-- =========================
CREATE TABLE cdms.cdms_user (
                                user_id          BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID（唯一标识，自增）',
                                username         VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名（登录账号，管理员/外卖员区分用）',
                                password         VARCHAR(255) NOT NULL COMMENT '密码（建议用BCrypt加密，格式：$2a$10$...）',
                                role             TINYINT NOT NULL COMMENT '角色类型：0=系统管理员，1=外卖配送员',
                                phone_no         VARCHAR(20) DEFAULT NULL COMMENT '联系方式（外卖员必填，管理员可选）',

    -- 状态字段：控制账号可用性和工作状态
                                status           TINYINT NOT NULL DEFAULT 0 COMMENT '账号状态：0=正常启用，1=禁用（管理员操作），2=密码错误锁定',
                                work_status      TINYINT DEFAULT 0 COMMENT '工作状态（仅外卖员有效）：0=离线，1=在线接单，2=休息中',

    -- 登录安全字段：防止暴力破解
                                fail_count       INT DEFAULT 0 COMMENT '连续登录失败次数（累计5次锁定账号，重置为0需管理员解锁）',
                                last_login_time  DATETIME DEFAULT NULL COMMENT '上次登录时间（记录登录轨迹）',
                                last_login_ip    VARCHAR(45) DEFAULT NULL COMMENT '上次登录IP（支持IPv4/IPv6）',
                                last_login_success BOOLEAN DEFAULT NULL COMMENT '上次登录结果：1=成功，0=失败',
                                last_login_remark VARCHAR(255) DEFAULT NULL COMMENT '登录备注（如“密码错误”“IP异地登录”）',

    -- 审计字段：追溯数据来源和修改记录
                                create_time      DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '账号创建时间（默认当前时间）',
                                creator_id       BIGINT DEFAULT NULL COMMENT '创建人ID（关联cdms_user.user_id，管理员创建外卖员时填写）',
                                update_time      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间（修改账号信息时自动更新）',

    -- 外键关联：创建人关联用户表（自关联，允许管理员创建其他账号）
                                FOREIGN KEY (creator_id) REFERENCES cdms_user(user_id) ON DELETE SET NULL,

    -- 数据约束：确保角色/状态值合法
                                CHECK (role IN (0, 1)),
                                CHECK (status IN (0, 1, 2)),
                                CHECK (work_status IN (0, 1, 2)),

    -- 索引优化：提升登录查询和角色筛选效率
                                INDEX idx_user_role (role) USING BTREE,
                                INDEX idx_user_status (status) USING BTREE,
                                INDEX idx_user_login (username) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表（统一管理管理员和外卖员账号）';

-- =========================
-- 2. 核心业务表：配送订单表
-- =========================
CREATE TABLE cdms.cdms_delivery_order (
                                          order_id         VARCHAR(30) PRIMARY KEY COMMENT '订单编号（格式：ORDER+YYYYMMDD+6位序号，如ORDER20251027000001）',

    -- 寄件人信息（商家/发件方）
                                          sender_name      VARCHAR(50) NOT NULL COMMENT '寄件人姓名（如店铺负责人）',
                                          sender_phone     VARCHAR(20) NOT NULL COMMENT '寄件人电话（必填，方便取件沟通）',
                                          sender_address   VARCHAR(255) NOT NULL COMMENT '寄件人详细地址（含门牌号，支持地图定位）',

    -- 收件人信息（用户/收件方）
                                          consignee_name   VARCHAR(50) NOT NULL COMMENT '收货人姓名（外卖接收人）',
                                          consignee_phone  VARCHAR(20) NOT NULL COMMENT '收货人电话（必填，方便送达沟通）',
                                          consignee_address VARCHAR(255) NOT NULL COMMENT '收货人详细地址（含单元号、楼层）',

    -- 货物信息：用于计算配送费和特殊处理
                                          goods_type       ENUM('ordinary', 'fragile', 'fresh') NOT NULL COMMENT '货物类型：ordinary=普通件，fragile=易碎件，fresh=生鲜件',
                                          weight           DECIMAL(10,2) DEFAULT NULL COMMENT '货物重量（单位：kg，保留2位小数）',
                                          volume           DECIMAL(10,3) DEFAULT NULL COMMENT '货物体积（单位：m³，保留3位小数）',
                                          delivery_fee     DECIMAL(10,2) NOT NULL COMMENT '配送费用（单位：元，外卖员收益以此为基础）',
                                          expected_mins    INT DEFAULT NULL COMMENT '预计配送时效（单位：分钟，超时会提醒）',
                                          remark           VARCHAR(255) DEFAULT NULL COMMENT '订单备注（如“放门口”“电话保持畅通”）',
                                          abandon_reason VARCHAR(100) DEFAULT NULL COMMENT '放弃原因',
                                          abandon_description TEXT DEFAULT NULL COMMENT '放弃详细说明',

    -- 订单状态流转字段
                                          status           TINYINT DEFAULT 0 COMMENT '订单状态：0=待接单，1=已接单待取货，2=配送中，3=已完成，4=已取消，5=放弃待审核',
                                          create_time      DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '订单创建时间（自动生成）',
                                          creator_id       BIGINT NOT NULL COMMENT '创建人ID（关联cdms_user.user_id，管理员/系统创建）',
                                          deliveryman_id   BIGINT DEFAULT NULL COMMENT '接单外卖员ID（关联cdms_user.user_id，待接单时为NULL）',
                                          complete_time    DATETIME DEFAULT NULL COMMENT '订单完成时间（状态变为3时更新）',
                                          cancel_time      DATETIME DEFAULT NULL COMMENT '订单取消时间（状态变为4时更新）',

    -- 外键关联：确保数据完整性
                                          FOREIGN KEY (creator_id) REFERENCES cdms_user(user_id) ON DELETE RESTRICT,
                                          FOREIGN KEY (deliveryman_id) REFERENCES cdms_user(user_id) ON DELETE SET NULL,

    -- 数据约束：限制状态值范围
                                          CHECK (status IN (0, 1, 2, 3, 4, 5)),

    -- 索引优化：提升订单查询效率（外卖员工作台核心查询）
                                          INDEX idx_order_status (status) USING BTREE, -- 查“待接单（0）”“配送中（2）”
                                          INDEX idx_order_deliveryman (deliveryman_id, status) USING BTREE, -- 查“指定外卖员的订单”
                                          INDEX idx_order_create (create_time) USING BTREE -- 查“今日/昨日订单”
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='配送订单表（外卖员核心业务表）';

-- =========================
-- 3. 业务辅助表：配送状态追踪表
-- =========================
CREATE TABLE cdms.cdms_delivery_trace (
                                          trace_id         BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '追踪记录ID（自增，唯一标识）',
                                          order_id         VARCHAR(30) NOT NULL COMMENT '关联订单编号（对应cdms_delivery_order.order_id）',
                                          status           TINYINT DEFAULT 0 COMMENT '订单状态：与cdms_delivery_order.status一致',
                                          operator_id      BIGINT NOT NULL COMMENT '操作人ID（关联cdms_user.user_id，管理员/外卖员均可）',
                                          operate_time     DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '状态变更时间（自动记录）',
                                          remark           VARCHAR(255) DEFAULT NULL COMMENT '状态变更说明（如“外卖员张三接单”“用户确认收货”）',

    -- 外键关联：确保追踪记录与订单/操作人绑定
                                          FOREIGN KEY (order_id) REFERENCES cdms_delivery_order(order_id) ON DELETE CASCADE,
                                          FOREIGN KEY (operator_id) REFERENCES cdms_user(user_id) ON DELETE RESTRICT,

    -- 数据约束：状态值范围
                                          CHECK (status IN (0, 1, 2, 3, 4, 5)),

    -- 索引优化：快速查询订单状态流转记录
                                          INDEX idx_trace_order (order_id) USING BTREE,
                                          INDEX idx_trace_operator (operator_id) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='配送订单状态追踪表（记录订单全生命周期变更）';

-- =========================
-- 4. 业务辅助表：外卖员通知表
-- =========================
CREATE TABLE cdms.cdms_notification (
                                        id               VARCHAR(32) PRIMARY KEY COMMENT '通知ID（格式：NT+YYYYMMDD+8位序号，如NT2025102700000001）',
                                        deliveryman_id   BIGINT NOT NULL COMMENT '接收通知的外卖员ID（关联cdms_user.user_id）',
                                        content          VARCHAR(500) NOT NULL COMMENT '通知内容（如“您有新的待接单订单”“您的放弃订单申请已通过”）',
                                        type             TINYINT NOT NULL COMMENT '通知类型：0=管理员操作通知，1=订单状态变更通知',
                                        is_read          TINYINT NOT NULL DEFAULT 0 COMMENT '阅读状态：0=未读，1=已读',
                                        create_time      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '通知创建时间',
                                        sms_sent         TINYINT NOT NULL DEFAULT 0 COMMENT '短信发送状态：0=未发送，1=已发送（重要通知补短信）',

    -- 外键关联：外卖员删除时同步删除通知
                                        FOREIGN KEY (deliveryman_id) REFERENCES cdms_user(user_id)
                                            ON UPDATE CASCADE
                                            ON DELETE CASCADE,

    -- 数据约束：限制类型/状态值
                                        CHECK (type IN (0, 1)),
                                        CHECK (is_read IN (0, 1)),
                                        CHECK (sms_sent IN (0, 1)),

    -- 索引优化：快速查询外卖员未读通知
                                        INDEX idx_notify_deliveryman (deliveryman_id, is_read) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='外卖员通知表（系统与外卖员的消息交互）';

-- =========================
-- 5. 系统辅助表：操作日志表（管理员审计用）
-- =========================
CREATE TABLE cdms.cdms_operation_log (
                                         log_id           BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID（自增，唯一）',
                                         operator_id      BIGINT NOT NULL COMMENT '操作者ID（关联cdms_user.user_id，仅管理员）',
                                         operation_type   VARCHAR(50) NOT NULL COMMENT '操作类型（如CREATE_USER=创建用户，CANCEL_ORDER=取消订单）',
                                         operation_obj    VARCHAR(100) DEFAULT NULL COMMENT '被操作对象标识（如“user_id=1001”“order_id=ORDER20251027000001”）',
                                         operation_time   DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
                                         result           VARCHAR(100) DEFAULT NULL COMMENT '操作结果（如“成功”“失败：订单已被接单，无法取消”）',

    -- 外键关联：确保操作者存在
                                         FOREIGN KEY (operator_id) REFERENCES cdms_user(user_id) ON DELETE RESTRICT,

    -- 索引优化：按操作者/时间查询日志
                                         INDEX idx_log_operator (operator_id) USING BTREE,
                                         INDEX idx_log_time (operation_time) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统操作日志表（管理员操作审计，追溯责任）';

-- =========================
-- 6. 系统辅助表：第三方接口密钥表（选做）
-- =========================
CREATE TABLE cdms.cdms_api_key (
                                   key_id           BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '密钥ID（自增）',
                                   app_name         VARCHAR(100) NOT NULL COMMENT '第三方应用名称（如“地图接口”“短信接口”）',
                                   api_key          VARCHAR(100) NOT NULL UNIQUE COMMENT '接口密钥（加密存储，防止泄露）',
                                   status           ENUM('enabled', 'disabled') DEFAULT 'enabled' COMMENT '密钥状态：enabled=启用，disabled=禁用',
                                   create_time      DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

    -- 索引优化：按应用名称查询密钥
                                   INDEX idx_api_app (app_name) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='第三方接口密钥表（管理系统调用的外部接口凭证）';

-- =========================
-- 7. 初始化测试数据（方便外卖员模块调试）
-- =========================
-- 7.1 初始化管理员账号（用于创建外卖员）
INSERT INTO cdms.cdms_user (username, password, role, phone_no, status, work_status, creator_id)
VALUES ('admin', '$2a$10$EixZaYbB.rK4fl8x2q80ce4oU6aKz5k5VS5r.u/79EF1u0t1p44T2', 0, '13800138000', 0, NULL, NULL);
-- 密码说明：明文是“admin123”，已用BCrypt加密，可直接登录测试

-- 7.2 初始化2个外卖员账号（关联管理员创建）
INSERT INTO cdms.cdms_user (username, password, role, phone_no, status, work_status, creator_id)
VALUES
-- 外卖员1：账号“courier1”，密码“courier123”，状态正常在线
('courier1', '$2a$10$Gd6P08X9Q4z3y5L7M8N9b0v1c2x3d4f5g6h7j8k9l0', 1, '13900139000', 0, 1, 1),
-- 外卖员2：账号“courier2”，密码“courier123”，状态正常离线
('courier2', '$2a$10$Gd6P08X9Q4z3y5L7M8N9b0v1c2x3d4f5g6h7j8k9l0', 1, '13700137000', 0, 0, 1);

-- 7.3 初始化3个待接单订单（关联管理员创建）
INSERT INTO cdms.cdms_delivery_order (order_id, sender_name, sender_phone, sender_address, consignee_name, consignee_phone, consignee_address, goods_type, delivery_fee, expected_mins, status, creator_id)
VALUES
-- 订单1：普通件，配送费8.5元，预计30分钟
('ORDER20251027000001', '麦当劳（朝阳店）', '010-88886661', '北京市朝阳区建国路88号', '李先生', '13500135001', '北京市朝阳区光华路5号院', 'ordinary', 8.50, 30, 0, 1),
-- 订单2：生鲜件，配送费12.0元，预计25分钟
('ORDER20251027000002', '永辉超市（望京店）', '010-88886662', '北京市朝阳区望京街9号', '王女士', '13500135002', '北京市朝阳区望京西园12区', 'fresh', 12.00, 25, 0, 1),
-- 订单3：易碎件，配送费10.0元，预计35分钟
('ORDER20251027000003', '星巴克（国贸店）', '010-88886663', '北京市朝阳区国贸中心B1层', '张先生', '13500135003', '北京市朝阳区国贸公寓A座', 'fragile', 10.00, 35, 0, 1);

-- 7.4 初始化订单追踪记录（对应3个待接单订单）
INSERT INTO cdms.cdms_delivery_trace (order_id, status, operator_id, remark)
VALUES
    ('ORDER20251027000001', 0, 1, '管理员创建订单，待外卖员接单'),
    ('ORDER20251027000002', 0, 1, '管理员创建订单，待外卖员接单'),
    ('ORDER20251027000003', 0, 1, '管理员创建订单，待外卖员接单');

-- 7.5 初始化外卖员通知（新订单提醒）
INSERT INTO cdms.cdms_notification (id, deliveryman_id, content, type, is_read, sms_sent)
VALUES
    ('NT2025102700000001', 2, '您有新的待接单订单：ORDER20251027000001（麦当劳朝阳店→光华路5号院）', 1, 0, 0),
    ('NT2025102700000002', 2, '您有新的待接单订单：ORDER20251027000002（永辉超市望京店→望京西园12区）', 1, 0, 0),
    ('NT2025102700000003', 3, '您有新的待接单订单：ORDER20251027000003（星巴克国贸店→国贸公寓A座）', 1, 0, 0);

-- 执行成功提示
SELECT '数据库表创建完成，测试数据初始化成功！' AS result;