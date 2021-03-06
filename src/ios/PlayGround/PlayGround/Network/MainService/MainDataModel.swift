//
//  MainDataModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/28.
//

import Foundation

struct HomeList: Codable {
    let liveRooms: [GeneralVideo]
    let videos: [GeneralVideo]
    let categories: [String]
    
    enum CodingKeys: String, CodingKey {
        case liveRooms = "rooms"
        case videos
        case categories
    }
}

struct GeneralVideo: Codable {
    let id: Int
    let title: String
    let hostNickname: String?
    let hostUuid: String?
    let uploaderNickname: String?
    let uploaderUuid: String?
    let fileLink: String?
    let thumbnail: String
    let hits: Int?
    let category: String? 
    let createdAt: String?
    let streamingId: String?
    let chatRoomId: String?
    let uuid: String?
    let likedAt: String?
    let lastViewedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case hostNickname
        case hostUuid
        case uploaderNickname
        case uploaderUuid
        case fileLink
        case hits
        case thumbnail
        case category
        case createdAt
        case streamingId
        case chatRoomId
        case uuid
        case likedAt
        case lastViewedAt
    }
}

enum Action: String {
    case Like = "LIKE"
    case Dislike = "DISLIKE"
    case Report = "REPORT"
}

struct NoticeResult: Codable {
    let result: [Notice]
    
    enum CodingKeys: String, CodingKey {
        case result
    }
}

struct Notice: Codable {
    let notiType: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case notiType
        case content
    }
}

struct FriendResult: Codable {
    let result: [Friend]
    
    enum CodingKeys: String, CodingKey {
        case result
    }
}

struct Friend: Codable {
    let nickname: String
    let profileImage: String
    let uuid: String
    
    enum CodingKeys: String, CodingKey {
        case nickname
        case profileImage
        case uuid
    }
}

struct WatchingInfo: Codable {
    let roomId: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case roomId
        case title
    }
}
