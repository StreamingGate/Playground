-- 1(uploader), 2(streamer), 3,4(viewer)
INSERT INTO users(id, email, uuid, nick_name, profile_image)
VALUES (1, 'u1@email.com', '11111111-1234-1234-123456789012', 'nick1', 'https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg'),
       (2, 'u2@email.com', '22222222-1234-1234-123456789012', 'nick2', 'https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg'),
       (3, 'u3@email.com', '33333333-1234-1234-123456789012', 'nick3', 'https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg'),
       (4, 'u4@email.com', '44444444-1234-1234-123456789012', 'nick4', 'https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg');

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
VALUES (1, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file1', '2022-01-26T11:0:0', 'NORMAL', 'u1@email.com'),
       (2, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file2', '2022-01-26T12:0:0', 'NORMAL', 'u1@email.com'),
       (3, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file3', '2022-01-26T13:0:0', 'NORMAL', 'u1@email.com'),
       (4, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file4', '2022-01-26T14:0:0', 'NORMAL', 'u1@email.com'),
       (5, 'https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8', 'file5', '2022-01-26T15:0:0', 'NORMAL', 'u1@email.com');

-- video
INSERT INTO video(id, title, uploader_nickname, users_id, hits, like_cnt, report_cnt, thumbnail, category, created_at, metadata_id)
VALUES (1, 'video1', 'nick1', 1, 2, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T11:0:0',1),
       (2, 'video2', 'nick1', 1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T12:0:0',2),
       (3, 'video3', 'nick1', 1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T13:0:0',3),
       (4, 'video4', 'nick1', 1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-26T14:0:0',4),
       (5, 'video5', 'nick1', 1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-26T15:0:0',5);

INSERT INTO viewed_history(id, liked, disliked, users_id, video_id)
VALUES (1, 0, 0, 3, 1),
       (2, 0, 0, 4, 1);

-- live_room
INSERT INTO live_room(id, title, host_nickname, users_id, like_cnt, report_cnt, thumbnail, category, created_at)
VALUES (1, 'live_room1', 'nick2', 2, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg', 'KPOP', '2022-01-27T11:0:0');

INSERT INTO live_viewer(id, liked, disliked, last_viewed_at, live_room_id, user_id)
VALUES (1, 0, 0, '2022-01-27T11:10:0', 1, 3),
       (2, 0, 0, '2022-01-27T11:10:0', 1, 4);

-- notification
INSERT INTO notification(id, noti_type, content, users_id)
VALUES (1, 'STREAMING', "{\"sender\":\"nick1\", \"profileImage\":\"https://www.1xbetkrs.com/wp-content/uploads/2020/03/2-3.jpg\", \"title\":\"live_room1\", \"roomId\":1}", 3);