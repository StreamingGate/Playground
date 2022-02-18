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

-- metadata
INSERT INTO metadata(id, file_link, file_name, size, video_created_at, state, uploader_email)
VALUES (1, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file1', 10000,
        '2022-01-26T1:0:0', 'NORMAL', 'u1@email.com'),
       (2, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file2', 10000,
        '2022-01-26T2:0:0', 'NORMAL', 'u1@email.com'),
       (3, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file3', 10000,
        '2022-01-26T3:0:0', 'NORMAL', 'u1@email.com'),
       (4, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file4', 10000,
        '2022-01-26T4:0:0', 'NORMAL', 'u1@email.com'),
       (5, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file5', 10000,
        '2022-01-26T5:0:0', 'NORMAL', 'u1@email.com'),
       (6, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file6', 10000,
        '2022-01-26T6:0:0', 'NORMAL', 'u2@email.com'),
       (7, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file7', 10000,
        '2022-01-26T7:0:0', 'NORMAL', 'u2@email.com'),
       (8, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file8', 10000,
        '2022-01-26T8:0:0', 'NORMAL', 'u2@email.com'),
       (9, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file9', 10000,
        '2022-01-26T9:0:0', 'NORMAL', 'u2@email.com'),
       (10, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file10', 10000,
        '2022-01-27T1:0:0', 'NORMAL', 'u2@email.com'),
       (11, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file11', 10000,
        '2022-01-27T2:0:0', 'NORMAL', 'u3@email.com'),
       (12, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file12', 10000,
        '2022-01-27T3:0:0', 'NORMAL', 'u3@email.com'),
       (13, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file13', 10000,
        '2022-01-27T4:0:0', 'NORMAL', 'u3@email.com'),
       (14, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file14', 10000,
        '2022-01-27T5:0:0', 'NORMAL', 'u3@email.com'),
       (15, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file15', 10000,
        '2022-01-27T6:0:0', 'NORMAL', 'u3@email.com'),
       (16, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file16', 10000,
        '2022-01-27T7:0:0', 'NORMAL', 'u4@email.com'),
       (17, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file17', 10000,
        '2022-01-27T8:0:0', 'NORMAL', 'u4@email.com'),
       (18, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file18', 10000,
        '2022-01-27T9:0:0', 'NORMAL', 'u4@email.com'),
       (19, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file19', 10000,
        '2022-01-28T1:0:0', 'NORMAL', 'u4@email.com'),
       (20, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file20', 10000,
        '2022-01-28T2:0:0', 'NORMAL', 'u4@email.com');

-- video
INSERT INTO video(id, uuid, title, content, users_id, hits, like_cnt, report_cnt, thumbnail, category, created_at, metadata_id)
VALUES (1, '00000001-1234-1234-999999999999', 'video1', 'test content', 1, 2, 1, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T1:0:0',1),
       (2, '00000002-1234-1234-999999999999', 'video2', 'test content',1, 2, 1, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T2:0:0',2),
       (3, '00000003-1234-1234-999999999999', 'video3', 'test content',1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T3:0:0',3),
       (4, '00000004-1234-1234-999999999999', 'video4', 'test content',1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T4:0:0',4),
       (5, '00000005-1234-1234-999999999999', 'video5', 'test content',1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T5:0:0',5),
       (6, '00000006-1234-1234-999999999999', 'video6', 'test content',2, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','SPORTS', '2022-01-26T6:0:0',6),
       (7, '00000007-1234-1234-999999999999', 'video7', 'test content',2, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','SPORTS', '2022-01-26T7:0:0',7),
       (8, '00000008-1234-1234-999999999999', 'video8', 'test content',2, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','SPORTS', '2022-01-26T8:0:0',8),
       (9, '00000009-1234-1234-999999999999', 'video9', 'test content',2, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','SPORTS', '2022-01-26T9:0:0',9),
       (10, '00000010-1234-1234-999999999999', 'video10', 'test content',2, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','SPORTS', '2022-01-27T1:0:0',10),
       (11, '00000011-1234-1234-999999999999', 'video11', 'test content',3, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T2:0:0',11),
       (12, '00000012-1234-1234-999999999999', 'video12', 'test content',3, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T3:0:0',12),
       (13, '00000013-1234-1234-999999999999', 'video13', 'test content',3, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T4:0:0',13),
       (14, '00000014-1234-1234-999999999999', 'video14', 'test content',3, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T5:0:0',14),
       (15, '00000015-1234-1234-999999999999', 'video15', 'test content',3, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T6:0:0',15),
       (16, '00000016-1234-1234-999999999999', 'video16', 'test content',4, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T7:0:0',16),
       (17, '00000017-1234-1234-999999999999', 'video17', 'test content',4, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T8:0:0',17),
       (18, '00000018-1234-1234-999999999999', 'video18', 'test content',4, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T9:0:0',18),
       (19, '00000019-1234-1234-999999999999', 'video19', 'test content',4, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-28T1:0:0',19),
       (20, '00000020-1234-1234-999999999999', 'video20', 'test content',4, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-28T2:0:0',20);

INSERT INTO viewed_history(id, liked, disliked, liked_at, last_viewed_at, viewed_progress, users_id, video_id)
VALUES (1, 0, 0, null, '2022-01-28T2:0:0', 10000, 3, 1),
       (2, 0, 0, null, '2022-01-28T2:0:0', 10000, 3, 2),
       (3, 1, 0, '2022-01-28T2:0:0', '2022-01-28T2:0:0', 10000, 4, 1),
       (4, 1, 0, '2022-01-28T2:0:0', '2022-01-28T2:0:0', 10000, 4, 2);

-- room
INSERT INTO room(id, uuid, title, host_uuid, content, users_id, like_cnt, report_cnt, thumbnail, category, created_at)
VALUES (1, '00000100-1234-1234-999999999999', 'test content', 'room1', '11111111-1234-1234-123456789012', 1, 1, 0,
        'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg', 'KPOP', '2022-01-27T11:0:0'),
       (2, '00000101-1234-1234-999999999999', 'test content', 'room2', '22222222-1234-1234-123456789012', 2, 0, 0,
        'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg', 'KPOP', '2022-01-27T12:0:0'),
       (3, '00000102-1234-1234-999999999999', 'test content', 'room3', '33333333-1234-1234-123456789012', 3, 0, 0,
        'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg', 'KPOP', '2022-01-27T13:0:0'),
       (4, '00000103-1234-1234-999999999999', 'test content', 'room4', '44444444-1234-1234-123456789012', 4, 0, 0,
        'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg', 'KPOP', '2022-01-27T14:0:0');

-- everyone -> room3
INSERT INTO room_viewer(id, liked, disliked, last_viewed_at, users_id, room_id)
VALUES (1, 1, 0, '2022-01-27T11:10:0', 2, 1),
       (2, 0, 1, '2022-01-27T11:10:0', 3, 1),
       (3, 0, 0, '2022-01-27T11:10:0', 4, 1);

-- notification
INSERT INTO notification(id, noti_type, content, users_id)
VALUES (1, 'STREAMING', "{\"sender\":\"nick1\", \"profileImage\":\"https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg\", \"title\":\"live_room1\", \"roomId\":1}", 3),
       (2, 'STREAMING', "{\"sender\":\"nick2\", \"profileImage\":\"https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg\", \"title\":\"live_room2\", \"roomId\":2}", 4),
       (3, 'STREAMING', "{\"sender\":\"nick3\", \"profileImage\":\"https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg\", \"title\":\"live_room3\", \"roomId\":3}", 1),
       (4, 'STREAMING', "{\"sender\":\"nick3\", \"profileImage\":\"https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg\", \"title\":\"live_room3\", \"roomId\":3}", 4),
       (5, 'STREAMING', "{\"sender\":\"nick4\", \"profileImage\":\"https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg\", \"title\":\"live_room4\", \"roomId\":4}", 2),
       (6, 'STREAMING', "{\"sender\":\"nick4\", \"profileImage\":\"https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg\", \"title\":\"live_room4\", \"roomId\":4}", 3);