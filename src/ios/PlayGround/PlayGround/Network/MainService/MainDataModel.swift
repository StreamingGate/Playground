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
        case liveRooms
        case videos
        case categories
    }
}

enum Category: String {
    case ALL = "전체"
    case EDU = "교육"
    case SPORTS = "스포츠"
    case KPOP = "K-POP"
}


struct LiveRoom: Codable {
    let id: Int
    let title: String
    let hostNickname: String
    let fileLink: String?
    let thumbnail: String
    let category: String
    let createdAt: String
    let streamingId: String?
    let chatRoomId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case hostNickname
        case fileLink
        case thumbnail
        case category
        case createdAt
        case streamingId
        case chatRoomId
    }
}


struct Video: Codable {
    let id: Int
    let title: String
    let uploaderNickname: String
    let hits: Int
    let fileLink: String?
    let thumbnail: String
    let category: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case uploaderNickname
        case hits
        case fileLink
        case thumbnail
        case category
        case createdAt
    }
}


struct GeneralVideo: Codable {
    let id: Int
    let title: String
    let hostNickname: String?
    let uploaderNickname: String?
    let fileLink: String?
    let thumbnail: String
    let hits: Int?
    let category: String
    let createdAt: String
    let streamingId: String?
    let chatRoomId: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case hostNickname
        case uploaderNickname
        case fileLink
        case hits
        case thumbnail
        case category
        case createdAt
        case streamingId
        case chatRoomId
    }
}
