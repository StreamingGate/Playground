//
//  ChatSendDelegate.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/27.
//

import Foundation

protocol ChatSendDelegate {
    func sendChatMessage(nickname: String, message: String, senderRole: String, chatType: String)
}
