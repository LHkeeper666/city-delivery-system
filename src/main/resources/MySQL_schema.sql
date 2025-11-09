CREATE SCHEMA IF NOT EXISTS cdms;
-- =========================
-- 用户表：user
-- =========================
CREATE TABLE cdms.cdms_user (
    user_id        BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '用户ID',
    username       VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名（唯一）',
    password       VARCHAR(255) NOT NULL COMMENT '加密后的密码',
    role           TINYINT NOT NULL COMMENT '角色类型：0=admin，1=deliveryman',
    phone_no       VARCHAR(20) DEFAULT NULL COMMENT '联系方式（配送员手机号）',

    -- 账号状态与工作状态
    status         TINYINT NOT NULL DEFAULT 0 COMMENT '账号状态：0=enabled，1=disabled，2=locked',
    work_status    TINYINT DEFAULT 0 COMMENT '工作状态：0=离线，1=在线，2=休息',

    -- 登录尝试相关字段
    fail_count     INT DEFAULT 0 COMMENT '连续登录失败次数（用于锁定账号）',
    last_login_time DATETIME DEFAULT NULL COMMENT '上次登录时间',
    last_login_ip   VARCHAR(45) DEFAULT NULL COMMENT '上次登录IP地址',
    last_login_success BOOLEAN DEFAULT NULL COMMENT '上次登录是否成功',
    last_login_remark VARCHAR(255) DEFAULT NULL COMMENT '上次登录备注（如失败原因）',

    -- 审计信息
    create_time    DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '账号创建时间',
    creator_id     BIGINT DEFAULT NULL COMMENT '创建人ID（管理员）',
    update_time    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    profit         DECIMAL(10,2) DEFAULT 0 COMMENT '总收入'

    FOREIGN KEY (creator_id) REFERENCES cdms_user(user_id),

        CHECK (role IN (0,1)),
    CHECK (status IN (0,1,2)),
    CHECK (work_status IN (0,1,2))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表（含上次登录信息）';

-- =========================
-- 配送订单表：delivery_order
-- =========================
/**
  这里我建议补充一个距离distance比较好，这里具体看一下我detail的jsp有关联错误
 */
CREATE TABLE cdms.cdms_delivery_order (
    order_id         VARCHAR(30) PRIMARY KEY COMMENT '订单编号',

    sender_name      VARCHAR(50) NOT NULL COMMENT '寄件人姓名',
    sender_phone     VARCHAR(20) NOT NULL COMMENT '寄件人电话',
    sender_address   VARCHAR(255) NOT NULL COMMENT '寄件人地址',

    consignee_name   VARCHAR(50) NOT NULL COMMENT '收货人姓名',
    consignee_phone  VARCHAR(20) NOT NULL COMMENT '收货人电话',
    consignee_address VARCHAR(255) NOT NULL COMMENT '收货人地址',

    goods_type       ENUM('ordinary', 'fragile', 'fresh') NOT NULL COMMENT '货物类型',
    weight           DECIMAL(10,2) DEFAULT NULL COMMENT '货物重量（kg）',
    volume           DECIMAL(10,3) DEFAULT NULL COMMENT '货物体积（m³）',
    delivery_fee     DECIMAL(10,2) NOT NULL COMMENT '配送费用（元）',
    platform_income  DECIMAL(10,2) DEFAULT 0 COMMENT '平台收入（抽成部分）',
    deliveryman_income DECIMAL(10,2) DEFAULT 0 COMMENT '配送员收入（剩余部分）',
    expected_mins   INT DEFAULT NULL COMMENT '预计配送时效（分钟）',
    remark           VARCHAR(255) DEFAULT NULL COMMENT '备注',

    status           TINYINT DEFAULT 0 COMMENT '订单状态：0-待接单，1-已接单待取货，2-配送中，3-已完成，4-已取消, 5-放弃待审核',
    create_time      DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    creator_id       BIGINT NOT NULL COMMENT '创建人ID（管理员）',
    deliveryman_id   BIGINT DEFAULT NULL COMMENT '接单配送员ID',
    complete_time    DATETIME DEFAULT NULL COMMENT '完成时间',
    cancel_time      DATETIME DEFAULT NULL COMMENT '取消时间',
    abandon_reason   VARCHAR(100) DEFAULT NULL COMMENT '放弃原因',
    abandon_description TEXT DEFAULT NULL COMMENT '放弃详细说明',

    FOREIGN KEY (creator_id) REFERENCES cdms_user(user_id),
    FOREIGN KEY (deliveryman_id) REFERENCES cdms_user(user_id),

    CHECK (status IN (0,1,2,3,4,5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='配送订单表';

-- =========================
-- 配送追踪表：delivery_trace
-- =========================
CREATE TABLE cdms.cdms_delivery_trace (
    trace_id        BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '追踪记录ID',
    order_id        VARCHAR(30) NOT NULL COMMENT '配送单编号',
    status           TINYINT DEFAULT 0 COMMENT '订单状态：0-待接单，1-已接单待取货，2-配送中，3-已完成，4-已取消, 5-放弃待审核',
    operator_id     BIGINT NOT NULL COMMENT '操作人（管理员或配送员）',
    operate_time    DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    remark          VARCHAR(255) DEFAULT NULL COMMENT '状态变更说明',
    FOREIGN KEY (order_id) REFERENCES cdms_delivery_order(order_id),
    FOREIGN KEY (operator_id) REFERENCES cdms_user(user_id),
    CHECK (status IN (0,1,2,3,4,5))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='配送单状态追踪表';

-- =========================
-- 通知表：notification
-- =========================
# CREATE TABLE cdms.cdms_notification (
#     id                VARCHAR(32) PRIMARY KEY COMMENT '通知ID（格式：NT + 日期 + 序号）',
#     deliveryman_id    BIGINT NOT NULL COMMENT '配送员ID（外键，关联 delivery_man.id）',
#     content           VARCHAR(500) NOT NULL COMMENT '通知内容（如：您的放弃订单申请已通过，订单已重回待接单池）',
#     type              TINYINT NOT NULL COMMENT '通知类型（0 = 管理员操作通知，1 = 订单状态通知）',
#     is_read           TINYINT NOT NULL DEFAULT 0 COMMENT '是否已读（0 = 未读，1 = 已读）',
#     create_time       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间（默认当前时间）',
#     sms_sent          TINYINT NOT NULL DEFAULT 0 COMMENT '是否发送短信（0 = 未发送，1 = 已发送）',
#
#     FOREIGN KEY (deliveryman_id) REFERENCES cdms_user(user_id)
#        ON UPDATE CASCADE
#        ON DELETE CASCADE,
#
#     CHECK (type IN (0,1)),
#     CHECK (is_read IN (0,1)),
#     CHECK (sms_sent IN (0,1))
# ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='通知表（与配送员表一对一关联，存储通知状态）';

-- =========================
-- 操作日志表：operation_log（选做）
-- =========================
CREATE TABLE cdms.cdms_operation_log (
    log_id           BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT '操作日志ID',
    operator_id      BIGINT NOT NULL COMMENT '操作者ID（管理员）',
    operation_type   VARCHAR(50) NOT NULL COMMENT '操作类型，如CREATE_USER、DELETE_ORDER',
    operation_obj    VARCHAR(100) DEFAULT NULL COMMENT '被操作对象标识，如user_id或order_id',
    operation_time   DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    result           VARCHAR(100) DEFAULT NULL COMMENT '结果描述，如成功/失败原因',
    FOREIGN KEY (operator_id) REFERENCES cdms_user(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统操作日志表';

-- =========================
-- 第三方接口密钥表：api_key（选做）
-- =========================
CREATE TABLE cdms.cdms_api_key (
    key_id        BIGINT PRIMARY KEY AUTO_INCREMENT COMMENT 'API密钥ID',
    app_name      VARCHAR(100) NOT NULL COMMENT '应用名称',
    api_key       VARCHAR(100) NOT NULL UNIQUE COMMENT '接口密钥',
    status        ENUM('enabled', 'disabled') DEFAULT 'enabled' COMMENT '密钥状态',
    create_time   DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='第三方应用API密钥表';