-- users
INSERT INTO users(id, email, pwd, uuid, nick_name, state, profile_image)
VALUES (1, 'u1@email.com', '$2a$10$hFNXIkB2dZ6ITSxoB1WXYuv4A5OTZybAzxoyEJJGFJyVJIZ.KF38a',
        '11111111-1234-1234-123456789012', 'nick1', 'STEADY','https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg'),
       (2, 'u2@email.com', '$2a$10$hFNXIkB2dZ6ITSxoB1WXYuv4A5OTZybAzxoyEJJGFJyVJIZ.KF38a',
        '22222222-1234-1234-123456789012', 'nick2', 'STEADY', 'https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg'),
       (3, 'u3@email.com', '$2a$10$hFNXIkB2dZ6ITSxoB1WXYuv4A5OTZybAzxoyEJJGFJyVJIZ.KF38a',
        '33333333-1234-1234-123456789012', 'nick3', 'STEADY', 'https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg'),
       (4, 'u4@email.com', '$2a$10$hFNXIkB2dZ6ITSxoB1WXYuv4A5OTZybAzxoyEJJGFJyVJIZ.KF38a',
        '44444444-1234-1234-123456789012', 'nick4', 'STEADY', 'https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg');

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
INSERT INTO metadata(id, file_link, file_name, video_created_at, state, uploader_email)
VALUES (1, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file1', '2022-01-26T1:0:0', 'NORMAL', 'u1@email.com'),
       (2, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file2', '2022-01-26T2:0:0', 'NORMAL', 'u1@email.com'),
       (3, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file3', '2022-01-26T3:0:0', 'NORMAL', 'u1@email.com'),
       (4, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file4', '2022-01-26T4:0:0', 'NORMAL', 'u1@email.com'),
       (5, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file5', '2022-01-26T5:0:0', 'NORMAL', 'u1@email.com'),
       (6, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file6', '2022-01-26T6:0:0', 'NORMAL', 'u2@email.com'),
       (7, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file7', '2022-01-26T7:0:0', 'NORMAL', 'u2@email.com'),
       (8, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file8', '2022-01-26T8:0:0', 'NORMAL', 'u2@email.com'),
       (9, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file9', '2022-01-26T9:0:0', 'NORMAL', 'u2@email.com'),
       (10, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file10', '2022-01-27T1:0:0', 'NORMAL', 'u2@email.com'),
       (11, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file11', '2022-01-27T2:0:0', 'NORMAL', 'u3@email.com'),
       (12, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file12', '2022-01-27T3:0:0', 'NORMAL', 'u3@email.com'),
       (13, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file13', '2022-01-27T4:0:0', 'NORMAL', 'u3@email.com'),
       (14, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file14', '2022-01-27T5:0:0', 'NORMAL', 'u3@email.com'),
       (15, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file15', '2022-01-27T6:0:0', 'NORMAL', 'u3@email.com'),
       (16, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file16', '2022-01-27T7:0:0', 'NORMAL', 'u4@email.com'),
       (17, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file17', '2022-01-27T8:0:0', 'NORMAL', 'u4@email.com'),
       (18, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file18', '2022-01-27T9:0:0', 'NORMAL', 'u4@email.com'),
       (19, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file19', '2022-01-28T1:0:0', 'NORMAL', 'u4@email.com'),
       (20, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file20', '2022-01-28T2:0:0', 'NORMAL', 'u4@email.com');

-- video
INSERT INTO video(id, title, users_id, hits, like_cnt, report_cnt, thumbnail, category, created_at, metadata_id)
VALUES (1, 'video1', 1, 2, 1, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T1:0:0',1),
       (2, 'video2', 1, 2, 1, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T2:0:0',2),
       (3, 'video3', 1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T3:0:0',3),
       (4, 'video4', 1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T4:0:0',4),
       (5, 'video5', 1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T5:0:0',5),
       (6, 'video6', 2, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','SPORTS', '2022-01-26T6:0:0',6),
       (7, 'video7', 2, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','SPORTS', '2022-01-26T7:0:0',7),
       (8, 'video8', 2, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','SPORTS', '2022-01-26T8:0:0',8),
       (9, 'video9', 2, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','SPORTS', '2022-01-26T9:0:0',9),
       (10, 'video10', 2, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','SPORTS', '2022-01-27T1:0:0',10),
       (11, 'video11', 3, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T2:0:0',11),
       (12, 'video12', 3, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T3:0:0',12),
       (13, 'video13', 3, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T4:0:0',13),
       (14, 'video14', 3, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T5:0:0',14),
       (15, 'video15', 3, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T6:0:0',15),
       (16, 'video16', 4, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T7:0:0',16),
       (17, 'video17', 4, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T8:0:0',17),
       (18, 'video18', 4, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-27T9:0:0',18),
       (19, 'video19', 4, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-28T1:0:0',19),
       (20, 'video20', 4, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-28T2:0:0',20);

INSERT INTO viewed_history(id, liked, disliked, last_viewed_at, users_id, video_id)
VALUES (1, 0, 0,'2022-01-28T2:0:0', 3, 1),
       (2, 0, 0,'2022-01-28T2:0:0', 3, 2),
       (3, 1, 0,'2022-01-28T2:0:0', 4, 1),
       (4, 1, 0,'2022-01-28T2:0:0', 4, 2);

-- room
INSERT INTO room(id, title, host_uuid, users_id, like_cnt, report_cnt, thumbnail, category, created_at)
VALUES (1, 'room1', '11111111-1234-1234-123456789012', 1, 1, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg', 'KPOP', '2022-01-27T11:0:0'),
       (2, 'room2', '22222222-1234-1234-123456789012', 2, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg', 'KPOP', '2022-01-27T12:0:0'),
       (3, 'room3', '33333333-1234-1234-123456789012', 3, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg', 'KPOP', '2022-01-27T13:0:0'),
       (4, 'room4', '44444444-1234-1234-123456789012', 4, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg', 'KPOP', '2022-01-27T14:0:0');

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