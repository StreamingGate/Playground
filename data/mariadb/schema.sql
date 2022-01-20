create table friend
(
    id               bigint not null auto_increment,
    fr_id            bigint,
    fr_nickname      varchar(255),
    fr_profile_image varchar(255),
    user_id          bigint,
    primary key (id)
) engine=InnoDB
create table friend_wait
(
    id                bigint not null auto_increment,
    nickname_receiver varchar(8),
    nickname_sender   varchar(8),
    primary key (id)
) engine=InnoDB
create table live_room
(
    id           bigint   not null auto_increment,
    category     varchar(10),
    chat_room_id varchar(255),
    content      varchar(5000),
    created_at   datetime,
    host_email   varchar(30),
    like_cnt     integer  not null,
    report_cnt   smallint not null,
    streaming_id varchar(255),
    title        varchar(100),
    users_id     bigint,
    primary key (id)
) engine=InnoDB
create table live_viewer
(
    id           bigint not null auto_increment,
    disliked     bit    not null,
    liked        bit    not null,
    role         varchar(10),
    live_room_id bigint,
    user_id      bigint,
    primary key (id)
) engine=InnoDB
create table metadata
(
    id               bigint not null auto_increment,
    file_link        TEXT,
    file_name        varchar(50),
    size             bigint,
    state            varchar(10),
    uploader_email   varchar(30),
    video_created_at datetime,
    primary key (id)
) engine=InnoDB
create table users
(
    id            bigint                         not null auto_increment,
    created_at    date default CURRENT_TIMESTAMP not null,
    deleted_at    date,
    email         varchar(255),
    last_at       date,
    modified_at   date,
    name          varchar(30),
    nick_name     varchar(255),
    profile_image varchar(255),
    pwd           varchar(61),
    state         varchar(255),
    time_zone     varchar(255),
    uuid          varchar(36),
    primary key (id)
) engine=InnoDB
create table video
(
    id          bigint   not null auto_increment,
    category    varchar(10),
    content     varchar(5000),
    created_at  datetime,
    hits        integer  not null,
    like_cnt    integer  not null,
    report_cnt  smallint not null,
    title       varchar(100),
    metadata_id bigint,
    users_id    bigint,
    primary key (id)
) engine=InnoDB
create table viewed_history
(
    id              bigint not null auto_increment,
    disliked        bit    not null,
    last_viewed_at  datetime,
    liked           bit    not null,
    liked_at        datetime,
    viewed_progress datetime,
    users_id        bigint,
    video_id        bigint,
    primary key (id)
) engine=InnoDB
alter table users
    add constraint UK_6dotkott2kjsp8vw4d0m25fb7 unique (email)
alter table friend
    add constraint FKeab81424e9dtc4a8hjlq4xiew foreign key (user_id) references users (id)
alter table live_room
    add constraint FK6vnxsrdcyyl32b00uvr4mdt2e foreign key (users_id) references users (id)
alter table live_viewer
    add constraint FK6swae88o8jsovsq1hbk50kvg6 foreign key (live_room_id) references live_room (id)
alter table live_viewer
    add constraint FKovjr1pogd7rjlfah9i13dm2o5 foreign key (user_id) references users (id)
alter table video
    add constraint FKlq8ktyke2jim62cq0gnu2ys3s foreign key (metadata_id) references metadata (id)
alter table video
    add constraint FKbumohg6sht50cdc9spya45hp5 foreign key (users_id) references users (id)
alter table viewed_history
    add constraint FKhs9qlglx4cco197tva5upwvc0 foreign key (users_id) references users (id)
alter table viewed_history
    add constraint FKjr82k6pv411gu2ji3865w6kqr foreign key (video_id) references video (id)