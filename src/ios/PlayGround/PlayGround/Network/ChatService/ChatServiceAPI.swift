//
//  ChatServiceAPI.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/26.
//

import Foundation
import StompClientLib

class ChatServiceAPI {
    static let shared = ChatServiceAPI()
    var socketClient = StompClientLib()
    
    let chatServiceUrl = "ws://localhost:8888/ws/websocket"
    
    func connectToSocket(viewModel: ChatViewModel) {
        let url = NSURL(string: chatServiceUrl)!
//        socketClient.certificateCheckEnabled = false
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: viewModel)
    }
    
    func enterRoom(roomId: String) {
        socketClient.subscribe(destination: "/topic/chat/room/\(roomId)")
    }
    
    func disconnectToSocket() {
        socketClient.disconnect()
    }
    
    func sendMessage(roomId: String, nickname: String, role: String, type: String, message: String) {
        socketClient.sendJSONForDict(dict: ["roomId": roomId, "nickname": nickname, "senderRole" : role, "chatType" : type, "message" : message] as NSDictionary, toDestination: "/app/chat/message/\(roomId)")
    }
}
