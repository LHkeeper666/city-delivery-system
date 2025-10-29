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
),
         ('cjh',
          '$2a$10$aLs7OA3oUfTt9TiPCfhr6.XWN0wknOTVa82rfd8nNQEtsyW0knn8S',
          1,
          '13609193515',
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

INSERT INTO cdms_delivery_order (
    order_id, sender_name, sender_phone, sender_address,
    consignee_name, consignee_phone, consignee_address,
    goods_type, weight, volume, delivery_fee,
    platform_income, deliveryman_income, expected_mins,
    remark, status, create_time, creator_id, deliveryman_id, complete_time, cancel_time
) VALUES
-- 1. 已完成订单
('ORD20251029001', '张三', '13800000001', '北京市海淀区中关村1号',
 '李四', '13900000001', '北京市朝阳区国贸A座',
 'ordinary', 2.50, 0.020, 20.00, 3.00, 17.00, 30,
 '快件，请尽快送达', 3, '2025-10-25 09:30:00', 1, 2, '2025-10-25 10:05:00', NULL),

-- 2. 已完成订单（易碎物品）
('ORD20251029002', '王五', '13800000002', '上海市浦东新区世纪大道100号',
 '赵六', '13900000002', '上海市徐汇区漕溪北路200号',
 'fragile', 1.20, 0.010, 25.00, 4.00, 21.00, 40,
 '小心轻放', 3, '2025-10-26 14:00:00', 1, 2, '2025-10-26 14:40:00', NULL),

-- 3. 配送中订单
('ORD20251029003', '孙七', '13800000003', '广州市天河区体育西路12号',
 '周八', '13900000003', '广州市越秀区东风路88号',
 'fresh', 3.00, 0.050, 30.00, 5.00, 25.00, 50,
 '冷链配送', 2, '2025-10-28 11:00:00', 1, 2, NULL, NULL),

-- 4. 待接单订单
('ORD20251029004', '钱九', '13800000004', '杭州市西湖区文三路300号',
 '吴十', '13900000004', '杭州市滨江区江南大道88号',
 'ordinary', 1.00, 0.008, 18.00, 2.50, 15.50, 35,
 '无特殊要求', 0, '2025-10-29 08:45:00', 1, NULL, NULL, NULL),

-- 5. 已取消订单
('ORD20251029005', '郑一', '13800000005', '深圳市南山区科技园南区1号',
 '冯二', '13900000005', '深圳市福田区中心区2号',
 'ordinary', 2.00, 0.015, 22.00, 3.50, 18.50, 45,
 '客户取消订单', 4, '2025-10-27 13:20:00', 1, 2, NULL, '2025-10-27 13:35:00');

INSERT INTO cdms_delivery_trace (order_id, status, operator_id, remark) VALUES
('O202501010001', 0, 1, '订单已创建'),
('O202501010001', 1, 2, '骑手已接单'),
('O202501010001', 2, 2, '骑手正在配送'),
('O202501010001', 3, 2, '配送完成');
