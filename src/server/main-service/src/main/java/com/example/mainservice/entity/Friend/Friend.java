//package com.example.mainservice.entity.Friend;
//
//import javax.persistence.Column;
//import javax.persistence.Entity;
//import javax.persistence.GeneratedValue;
//import javax.persistence.GenerationType;
//import javax.persistence.Id;
//import javax.persistence.JoinColumn;
//import javax.persistence.ManyToOne;
//
//import com.example.mainservice.entity.User.UserEntity;
//
//import lombok.Getter;
//import lombok.NoArgsConstructor;
//
//@NoArgsConstructor
//@Getter
//@Entity
//public class Friend {
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private Long id;
//
//    @Column(name = "fr_id")
//    private Long friendId;
//
//    @Column(name = "fr_nickname")
//    private String friendNickname;
//
//    @Column(name = "fr_profile_image")
//    private String friendProfileImage;
//
//    @ManyToOne
//    @JoinColumn(name = "user_id")
//    private UserEntity userEntity;
//
//}
