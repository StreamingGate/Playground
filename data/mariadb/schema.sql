create table friend
(
    users_id  bigint not null,
    friend_id bigint not null
) engine=InnoDB;
create table friend_wait
(
    id                   bigint not null auto_increment,
    sender_nickname      varchar(8),
    sender_profile_image TEXT,
    sender_uuid          varchar(36),
    users_id             bigint,
    primary key (id)
) engine=InnoDB;
create table metadata
(
    id               bigint not null auto_increment,
    file_link        TEXT,
    file_name        varchar(50),
    size             bigint,
    state            varchar(10),
    uploader_email   varchar(255),
    video_created_at datetime,
    primary key (id)
) engine=InnoDB;
create table notification
(
    id        bigint not null auto_increment,
    content   varchar(255),
    noti_type varchar(255),
    users_id  bigint,
    primary key (id)
) engine=InnoDB;
create table room
(
    id         bigint   not null auto_increment,
    category   varchar(10),
    content    varchar(5000),
    created_at datetime,
    host_uuid  varchar(36),
    like_cnt   integer  not null,
    report_cnt smallint not null,
    thumbnail  TEXT,
    title      varchar(100),
    uuid       varchar(36),
    users_id   bigint,
    primary key (id)
) engine=InnoDB;
create table room_viewer
(
    id             bigint not null auto_increment,
    disliked       bit    not null,
    last_viewed_at datetime,
    liked          bit    not null,
    liked_at       datetime,
    room_id        bigint,
    users_id       bigint,
    primary key (id)
) engine=InnoDB;
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
    profile_image TEXT,
    pwd           varchar(61),
    state         varchar(255),
    time_zone     varchar(255),
    uuid          varchar(36),
    primary key (id)
) engine=InnoDB;
create table video
(
    id          bigint   not null auto_increment,
    category    varchar(10),
    content     varchar(5000),
    created_at  datetime,
    hits        integer  not null,
    like_cnt    integer  not null,
    report_cnt  smallint not null,
    thumbnail   TEXT,
    title       varchar(100),
    uuid        varchar(36),
    metadata_id bigint,
    users_id    bigint,
    primary key (id)
) engine=InnoDB;
create table viewed_history
(
    id              bigint not null auto_increment,
    disliked        bit    not null,
    last_viewed_at  datetime,
    liked           bit    not null,
    liked_at        datetime,
    viewed_progress bigint,
    users_id        bigint,
    video_id        bigint,
    primary key (id)
) engine=InnoDB;
alter table users
    add constraint UK_6dotkott2kjsp8vw4d0m25fb7 unique (email);
alter table friend
    add constraint FK5j28qgyvon52ycu9sfieraerm foreign key (friend_id) references users (id);
alter table friend
    add constraint FK77hwidnt50k76utjsr02f15dx foreign key (users_id) references users (id);
alter table friend_wait
    add constraint FK5m461lrdbrvaajjaj3v0upu1h foreign key (users_id) references users (id);
alter table notification
    add constraint FKcvhy30biu2isnx5ovm0i9i7b7 foreign key (users_id) references users (id);
alter table room
    add constraint FK4s0mr7ub1816c1yrbmkdhx389 foreign key (users_id) references users (id);
alter table room_viewer
    add constraint FK9a6niaj5nc9ds2bpo8a06l190 foreign key (room_id) references room (id);
alter table room_viewer
    add constraint FK8vxuommdfv8s4q142lagn2sq8 foreign key (users_id) references users (id);
alter table video
    add constraint FKlq8ktyke2jim62cq0gnu2ys3s foreign key (metadata_id) references metadata (id);
alter table video
    add constraint FKbumohg6sht50cdc9spya45hp5 foreign key (users_id) references users (id);
alter table viewed_history
    add constraint FKhs9qlglx4cco197tva5upwvc0 foreign key (users_id) references users (id);
alter table viewed_history
    add constraint FKjr82k6pv411gu2ji3865w6kqr foreign key (video_id) references video (id);