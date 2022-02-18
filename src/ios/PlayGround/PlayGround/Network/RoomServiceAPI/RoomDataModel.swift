//
//  RoomDataModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/09.
//

import Foundation

struct RoomInfo: Codable {
    let roomId: Int
    let uuid: String?
    let hostNickname: String?
    let hostUuid: String
    let title: String
    let content: String?
    let likeCnt: Int
    let category: String
    let createdAt: String?
    let reportCnt: Int
    let thumbnail: String
    let liked: Bool
    let disliked: Bool
    
    enum CodingKeys: String, CodingKey {
        case roomId
        case uuid
        case hostNickname
        case hostUuid
        case title
        case content
        case likeCnt
        case category
        case createdAt
        case reportCnt
        case thumbnail
        case liked
        case disliked
    }
}
