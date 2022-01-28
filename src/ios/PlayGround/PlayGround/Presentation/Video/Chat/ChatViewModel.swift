//
//  ChatViewModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/27.
//

import Foundation
import UIKit
import StompClientLib
import Combine

class ChatViewModel {
    @Published var chatList: [ChatData] = []
    var roomId = ""
    var isMaximum = false
    
    func connectToSocket() {
        ChatServiceAPI.shared.connectToSocket(viewModel: self)
    }
    
    func disconnectToSocket() {
        ChatServiceAPI.shared.disconnectToSocket()
    }
    
    func sendMessage(message: String, nickname: String, type: String, role: String) {
        ChatServiceAPI.shared.sendMessage(roomId: self.roomId, nickname: nickname, role: role, type: type, message: message)
    }
}

extension ChatViewModel: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        guard let data = jsonBody as? [String: Any], let chatData = DataHelper.dictionaryToObject(objectType: ChatData.self, dictionary: data) else {
            print("cannot unwrap")
            return
        }
        // 최대 500개까지만 보여지도록
        if chatList.count < 500 {
            self.chatList.append(chatData)
        } else {
            isMaximum = true
            var newList = self.chatList
            newList.append(chatData)
            newList.removeFirst()
            self.chatList = newList
        }
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("did disconnect")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("did connect")
        ChatServiceAPI.shared.enterRoom(roomId: self.roomId)
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
