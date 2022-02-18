//
//  UserDataModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/19.
//

import Foundation
import UIKit

struct UserInfo: Codable {
    let email: String
    let profileImage: String
    let name: String?
    let nickName: String?
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case email
        case profileImage
        case name
        case nickName
        case refreshToken
    }
}

struct ChannelInfo: Codable {
    let email: String
    let profileImage: String
    let name: String?
    let nickName: String?
    let friendCnt: Int
    let uploadCnt: Int
    let uuid: String
    
    enum CodingKeys: String, CodingKey {
        case email
        case profileImage
        case name
        case nickName
        case friendCnt
        case uploadCnt
        case uuid
    }
}
