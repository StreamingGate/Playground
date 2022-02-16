//
//  ChatServiceAPI.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/26.
//

import Foundation
import StompClientLib
import SwiftKeychainWrapper

class ChatServiceAPI {
    static let shared = ChatServiceAPI()
    var socketClient = StompClientLib()
    let chatServiceUrl = "ws://localhost:8888/ws/websocket"
    
    func connectToSocket(viewModel: ChatViewModel) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue), let url = NSURL(string: chatServiceUrl) else { return }
//        socketClient.certificateCheckEnabled = false
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: viewModel, connectionHeaders: ["hear-beat": "10000,10000", "accept-version":"1.1,1.0", "token": tokenInfo])
    }
    
    func enterRoom(roomId: String) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        socketClient.subscribeWithHeader(destination: "/topic/chat/enter/\(roomId)", header: ["uuid": uuid])
        socketClient.subscribe(destination: "/topic/chat/room/\(roomId)")
    }
    
    func disconnectToSocketWithHeader(header: [String: String]) {
        socketClient.disconnectWithHeader(header: header)
    }
    
    func disconnectToSocket() {
        socketClient.disconnect()
    }
    
    /**
     채팅 전송
     - Parameters:
        - roomId: chatting room id
        - nickname: user nickname
        - role: user role
        - type: message type (NORMAL/PINNED)
        - message: message content
     */
    func sendMessage(roomId: String, nickname: String, role: String, type: String, message: String) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        socketClient.sendJSONForDict(dict: ["roomUuid": roomId, "uuid": uuid, "nickname": nickname, "senderRole" : role, "chatType" : type, "message" : message] as NSDictionary, toDestination: "/app/chat/message/\(roomId)")
    }
    
    }
}
