//
//  VideoDataModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/08.
//

import Foundation
import UIKit

struct VideoInfo: Codable {
    let title: String
    let content: String?
    let videoUuid: String?
    let streamingUrl: String
    let shareUrl: String
    let category: String
    let hits: Int
    let likeCnt: Int
    let uploaderProfileImage: String
    let uploaderNickname: String
    let subscriberCnt: Int
    let liked: Bool
    let disliked: Bool
    
    enum CodingKeys: String, CodingKey {
        case title
        case content
        case videoUuid
        case streamingUrl
        case shareUrl
        case category
        case hits
        case likeCnt
        case uploaderProfileImage
        case uploaderNickname
        case subscriberCnt
        case liked
        case disliked
    }
}

