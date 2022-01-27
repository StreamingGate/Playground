-- 1(uploader), 2(streamer), 3,4(viewer)
INSERT INTO users(id, email, uuid, nick_name)
VALUES (1, 'u1@email.com', '11111111-1234-1234-123456789012', 'nick1'),
       (2, 'u2@email.com', '22222222-1234-1234-123456789012', 'nick2'),
       (3, 'u3@email.com', '33333333-1234-1234-123456789012', 'nick3'),
       (4, 'u4@email.com', '44444444-1234-1234-123456789012', 'nick4');

-- 1(2 hits)
INSERT INTO video(id, title, uploader_nickname, users_id, hits, like_cnt, report_cnt, thumbnail, category, created_at)
VALUES (1, 'video1', 'nick1', 1, 2, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T11:0:0'),
       (2, 'video2', 'nick1', 1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T12:0:0'),
       (3, 'video3', 'nick1', 1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','KPOP', '2022-01-26T13:0:0'),
       (4, 'video4', 'nick1', 1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-26T14:0:0'),
       (5, 'video5', 'nick1', 1, 0, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg','EDU', '2022-01-26T15:0:0');

INSERT INTO viewed_history(id, liked, disliked, users_id, video_id)
VALUES (1, 0, 0, 3, 1),
       (2, 0, 0, 4, 1);

-- 1(2 hits)
INSERT INTO live_room(id, title, host_nickname, users_id, like_cnt, report_cnt, thumbnail, category, created_at)
VALUES (1, 'live_room1', 'nick2', 2, 0, 0, 'https://cdn.the-scientist.com/assets/articleNo/65065/aImg/29449/image-of-the-day-jasper-the-cat-t.jpg', 'KPOP', '2022-01-27T11:0:0');

INSERT INTO live_viewer(id, liked, disliked, last_viewed_at, live_room_id, user_id)
VALUES (1, 0, 0, '2022-01-27T11:10:0', 1, 3),
       (2, 0, 0, '2022-01-27T11:10:0', 1, 4);