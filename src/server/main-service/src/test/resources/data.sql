-- users
INSERT INTO users(id, email, pwd, uuid, name, nick_name, state, profile_image, created_at, modified_at)
VALUES (1, 'u1@email.com', '$2a$10$hFNXIkB2dZ6ITSxoB1WXYuv4A5OTZybAzxoyEJJGFJyVJIZ.KF38a',
        '11111111-1234-1234-123456789012', 'name1', 'nick1', 'STEADY',
        'https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg', '2022-01-26T1:0:0', '2022-01-26T1:0:0'),
       (2, 'u2@email.com', '$2a$10$hFNXIkB2dZ6ITSxoB1WXYuv4A5OTZybAzxoyEJJGFJyVJIZ.KF38a',
        '22222222-1234-1234-123456789012', 'name2', 'nick2', 'STEADY',
        'https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg', '2022-01-26T1:0:0', '2022-01-26T1:0:0'),
       (3, 'u3@email.com', '$2a$10$hFNXIkB2dZ6ITSxoB1WXYuv4A5OTZybAzxoyEJJGFJyVJIZ.KF38a',
        '33333333-1234-1234-123456789012', 'name3', 'nick3', 'STEADY',
        'https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg', '2022-01-26T1:0:0', '2022-01-26T1:0:0'),
       (4, 'u4@email.com', '$2a$10$hFNXIkB2dZ6ITSxoB1WXYuv4A5OTZybAzxoyEJJGFJyVJIZ.KF38a',
        '44444444-1234-1234-123456789012', 'name4', 'nick4', 'STEADY',
        'https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg', '2022-01-26T1:0:0', '2022-01-26T1:0:0');

-- friend relation:
-- 1 2
-- | |
-- 3-4
INSERT INTO friend(users_id, friend_id)
VALUES (1, 3),
       (2, 4),
       (3, 1),
       (3, 4),
       (4, 2),
       (4, 3);