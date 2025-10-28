CREATE SCHEMA IF NOT EXISTS cdms;
-- ============================================
-- 用户表：user
-- ============================================
CREATE TABLE cdms_user (
    user_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role TINYINT NOT NULL,                         -- 0=admin，1=deliveryman
    phone_no VARCHAR(20),

    status TINYINT NOT NULL DEFAULT 0,              -- 0=enabled，1=disabled，2=locked
    work_status TINYINT DEFAULT 0,                  -- 0=离线，1=在线，2=休息

    fail_count INT DEFAULT 0,
    last_login_time TIMESTAMP,
    last_login_ip VARCHAR(45),
    last_login_success BOOLEAN,
    last_login_remark VARCHAR(255),

    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    creator_id BIGINT,
    update_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    profit DECIMAL(10,2),

    FOREIGN KEY (creator_id) REFERENCES cdms_user(user_id),

    CHECK (role IN (0,1)),
    CHECK (status IN (0,1,2)),
    CHECK (work_status IN (0,1,2))
);

-- ============================================
-- 配送订单表：delivery_order
-- ============================================
CREATE TABLE cdms_delivery_order (
    order_id VARCHAR(30) PRIMARY KEY,

    sender_name VARCHAR(50) NOT NULL,
    sender_phone VARCHAR(20) NOT NULL,
    sender_address VARCHAR(255) NOT NULL,

    consignee_name VARCHAR(50) NOT NULL,
    consignee_phone VARCHAR(20) NOT NULL,
    consignee_address VARCHAR(255) NOT NULL,

    goods_type VARCHAR(20) NOT NULL,                -- ordinary, fragile, fresh
    weight DECIMAL(10,2),
    volume DECIMAL(10,3),
    delivery_fee DECIMAL(10,2) NOT NULL,
    platform_income  DECIMAL(10,2),
    deliveryman_income DECIMAL(10,2),
    expected_mins INT,
    remark VARCHAR(255),

    status TINYINT DEFAULT 0,                       -- 0-待接单, 1-已接单, 2-配送中, 3-已完成, 4-已取消, 5-放弃待审核
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    creator_id BIGINT NOT NULL,
    deliveryman_id BIGINT,
    complete_time TIMESTAMP,
    cancel_time TIMESTAMP,

    FOREIGN KEY (creator_id) REFERENCES cdms_user(user_id),
    FOREIGN KEY (deliveryman_id) REFERENCES cdms_user(user_id),

    CHECK (status IN (0,1,2,3,4,5))
);

-- ============================================
-- 配送追踪表：delivery_trace
-- ============================================
CREATE TABLE cdms_delivery_trace (
    trace_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(30) NOT NULL,
    status TINYINT DEFAULT 0,
    operator_id BIGINT NOT NULL,
    operate_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    remark VARCHAR(255),

    FOREIGN KEY (order_id) REFERENCES cdms_delivery_order(order_id),
    FOREIGN KEY (operator_id) REFERENCES cdms_user(user_id),

    CHECK (status IN (0,1,2,3,4,5))
);

-- ============================================
-- 通知表：notification
-- ============================================
CREATE TABLE cdms_notification (
    id VARCHAR(32) PRIMARY KEY,
    deliveryman_id BIGINT NOT NULL,
    content VARCHAR(500) NOT NULL,
    type TINYINT NOT NULL,                          -- 0=管理员操作通知, 1=订单状态通知
    is_read TINYINT NOT NULL DEFAULT 0,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    sms_sent TINYINT NOT NULL DEFAULT 0,

    FOREIGN KEY (deliveryman_id) REFERENCES cdms_user(user_id)
      ON UPDATE CASCADE
      ON DELETE CASCADE,

    CHECK (type IN (0,1)),
    CHECK (is_read IN (0,1)),
    CHECK (sms_sent IN (0,1))
);

-- ============================================
-- 操作日志表：operation_log
-- ============================================
CREATE TABLE cdms_operation_log (
    log_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    operator_id BIGINT NOT NULL,
    operation_type VARCHAR(50) NOT NULL,
    operation_obj VARCHAR(100),
    operation_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    result VARCHAR(100),

    FOREIGN KEY (operator_id) REFERENCES cdms_user(user_id)
);

-- ============================================
-- 第三方接口密钥表：api_key
-- ============================================
CREATE TABLE cdms_api_key (
    key_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    app_name VARCHAR(100) NOT NULL,
    api_key VARCHAR(100) NOT NULL UNIQUE,
    status VARCHAR(20) DEFAULT 'enabled',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CHECK (status IN ('enabled', 'disabled'))
);

