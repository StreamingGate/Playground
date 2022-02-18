//
//  StatusDataModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/14.
//

import Foundation
import UIKit

struct FriendWatchList: Codable {
    let result: [FriendWatch]
    
    enum CodingKeys: String, CodingKey {
        case result
    }
}

struct FriendWatch: Codable {
    let uuid: String
    let friendUuids: [String]
    var status: Bool
    var id: Int?
    var type: Int?
    var videoRoomUuid: String?
    var title: String?
    let nickname: String
    let profileImage: String
    let addOrDelete: Bool?
    let updateTargetUuid: String?
}
