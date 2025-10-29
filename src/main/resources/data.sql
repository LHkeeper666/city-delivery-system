INSERT INTO cdms_user (
    username,
    password,
    role,
    phone_no,
    status,
    work_status,
    fail_count,
    last_login_success,
    create_time
) VALUES (
    'admin',
    '{noop}1234',      -- 测试阶段可用明文，生产建议用加密（如BCrypt）
    0,             -- 角色：0=admin
    '13800000000',
    0,             -- 启用
    0,             -- 离线
    0,
    TRUE,
    CURRENT_TIMESTAMP
 ), (
     'deliveryman1',
     '{noop}1234',
     1,
     '11111111111',
     0,
     1,
     0,
     TRUE,
     CURRENT_TIMESTAMP
);

INSERT INTO cdms_delivery_order (
    order_id,
    sender_name, sender_phone, sender_address,
    consignee_name, consignee_phone, consignee_address,
    goods_type, weight, volume, delivery_fee, platform_income, deliveryman_income,
    expected_mins, remark,
    status, creator_id, deliveryman_id
) VALUES
    ('O202501010001',
     '张三', '18888888888', '北京市海淀区XX小区',
     '李四', '19999999999', '上海市浦东新区YY路',
     'fragile', 2.50, 0.012, 18.00, 5.00, 13.00,
     45, '易碎品，小心轻放',
     2, 1, 2
    );
INSERT INTO cdms_delivery_order (
    order_id,
    sender_name, sender_phone, sender_address,
    consignee_name, consignee_phone, consignee_address,
    goods_type, weight, volume, delivery_fee,
    expected_mins,
    status, creator_id
) VALUES
    ('O202501010002',
     '王五', '17777777777', '广州市天河区AA街',
     '赵六', '16666666666', '深圳市南山区BB社区',
     'ordinary', 1.10, 0.010, 12.00,
     30,
     0, 1
    );

INSERT INTO cdms_delivery_trace (order_id, status, operator_id, remark) VALUES
('O202501010001', 0, 1, '订单已创建'),
('O202501010001', 1, 2, '骑手已接单'),
('O202501010001', 2, 2, '骑手正在配送'),
('O202501010001', 3, 2, '配送完成');
