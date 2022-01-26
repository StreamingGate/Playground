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
    
    let chatServiceUrl = "ws://\(GatewayManager.shared.gatewayAddress)/chat-service/ws/websocket"
    
    func connectToSocket() {
        let url = NSURL(string: chatServiceUrl)!
//        socketClient.certificateCheckEnabled = false
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: self)
    }
    
    func enterRoom(roomId: String) {
        socketClient.subscribe(destination: "/topic/chat/room/\(roomId)")
    }
    
    func sendMessage(roomId: String, nickname: String, role: String, type: String, message: String) {
        socketClient.sendJSONForDict(dict: ["roomId": roomId, "nickname": nickname, "senderRole" : role, "chatType" : type, "message" : message] as NSDictionary, toDestination: "/app/chat/message/\(roomId)")
    }
}

extension ChatServiceAPI: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("did Receice Message: \(jsonBody), \(stringBody)")
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("did disconnect")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("did connect")
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("did send receipt")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("did send error: \(description)")
    }
    
    func serverDidSendPing() {
        print("server did send ping")
    }
}
