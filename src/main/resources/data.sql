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
    '123456',      -- 测试阶段可用明文，生产建议用加密（如BCrypt）
    0,             -- 角色：0=admin
    '13800000000',
    0,             -- 启用
    0,             -- 离线
    0,
    TRUE,
    CURRENT_TIMESTAMP
 );