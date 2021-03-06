//
//  ChatDataModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/27.
//

import Foundation

struct ChatData: Codable {
    let chatType: String
    let message: String
    let nickname: String
    let roomUuid: String
    let senderRole: String
    let profileImage: String
    let timeStamp: String
}

struct ChatInitialData: Codable {
    let uuid: String
    let userCnt: Int
    let pinnedChat: ChatData?
    
    enum CodingKeys: String, CodingKey {
        case uuid
        case userCnt
        case pinnedChat
    }
}
