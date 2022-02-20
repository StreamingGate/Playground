//
//  ChatViewModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/27.
//

import Foundation
import UIKit
import StompClientLib
import SwiftKeychainWrapper
import Combine

class ChatViewModel {
    var senderRole: String
    
    init(senderRole: String) {
        self.senderRole = senderRole
    }
    
    @Published var chatList: [ChatData] = []
    @Published var userCount = 0
    @Published var pinned: ChatData?
    @Published var isValid = true
    
    var isLive = false
    var roomId = ""
    var isMaximum = false
    
    func connectToSocket() {
        ChatServiceAPI.shared.connectToSocket(viewModel: self)
        ChatServiceAPI.shared.loadInitialChat(uuid: self.roomId) { result in
            guard let initialInfo = result["data"] as? ChatInitialData else { return }
            self.userCount = initialInfo.userCnt
            self.pinned = initialInfo.pinnedChat
        }
        
    }
    
    func disconnectToSocket() {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        ChatServiceAPI.shared.disconnectToSocketWithHeader(header: ["uuid": uuid, "roomUuid": self.roomId, "senderRole": senderRole])
    }
    
    func sendMessage(message: String, nickname: String, type: String) {
        ChatServiceAPI.shared.sendMessage(roomId: self.roomId, nickname: nickname, role: self.senderRole, type: type, message: message)
    }
}

extension ChatViewModel: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        guard let data = jsonBody as? [String: Any] else { return }
        if let chatData = DataHelper.dictionaryToObject(objectType: ChatData.self, dictionary: data) {
            print("chatData received")
            // 최대 500개까지만 보여지도록
            if chatData.chatType == "PINNED" {
                self.pinned = chatData
            }
            if chatList.count < 500 {
                self.chatList.append(chatData)
            } else {
                isMaximum = true
                var newList = self.chatList
                newList.append(chatData)
                newList.removeFirst()
                self.chatList = newList
            }
        } else if let countData = data["userCnt"] as? Int {
            self.userCount = countData
        } else if let error = data["errorCode"] as? String, error == "C003" {
            self.isValid = false
        }
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("did disconnect")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("did chat connect")
        ChatServiceAPI.shared.enterRoom(roomId: self.roomId)
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("did chat send receipt")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print("did chat send error: \(description)")
    }
    
    func serverDidSendPing() {
        print("chat server did send ping")
    }
}
