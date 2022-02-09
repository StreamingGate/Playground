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
    
    let chatServiceUrl = "ws://3.34.152.141:8888/ws/websocket"
    
    func connectToSocket(viewModel: ChatViewModel) {
        let url = NSURL(string: chatServiceUrl)!
//        socketClient.certificateCheckEnabled = false
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: viewModel, connectionHeaders: ["hear-beat": "10000,10000", "accept-version":"1.1,1.0"])
    }
    
    func enterRoom(roomId: String) {
        socketClient.subscribe(destination: "/topic/chat/room/\(roomId)")
    }
    
    func disconnectToSocket() {
        socketClient.disconnect()
    }
    
    func sendMessage(roomId: String, nickname: String, role: String, type: String, message: String) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        socketClient.sendJSONForDict(dict: ["roomId": roomId, "uuid": uuid, "nickname": nickname, "senderRole" : role, "chatType" : type, "message" : message] as NSDictionary, toDestination: "/app/chat/message/\(roomId)")
    }
}
