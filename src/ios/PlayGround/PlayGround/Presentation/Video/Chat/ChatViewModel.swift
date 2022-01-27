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
    var roomId = "e48b352a-111f-4b49-8a86-4ba9e6be3495"
    
    func connectToSocket() {
        ChatServiceAPI.shared.connectToSocket(viewModel: self)
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
        self.chatList.append(chatData)
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
