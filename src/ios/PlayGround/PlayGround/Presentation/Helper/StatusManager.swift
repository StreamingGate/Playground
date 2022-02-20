//
//  StatusViewModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/14.
//

import Foundation
import UIKit
import StompClientLib
import SwiftKeychainWrapper
import Combine

class StatusManager {
    static let shared = StatusManager()
    
    @Published var friendWatchList: [FriendWatch] = []
    @Published var isValid = true
    
    func connectToSocket() {
        StatusServiceAPI.shared.connectToSocket(manager: self)
    }
    
    func disconnectToSocket() {
        StatusServiceAPI.shared.disconnectToSocket()
    }
    
    func startWatchingVideo(id: Int, type: Int, videoRoomUuid: String, title: String) {
        StatusServiceAPI.shared.startWatchingVideo(id: id, type: type, videoRoomUuid: videoRoomUuid, title: title)
    }
    
    func stopWatchingVideo() {
        StatusServiceAPI.shared.stopWatchingVideo()
    }
}

extension StatusManager: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        guard let data = jsonBody as? [String: Any] else { return }
        guard let friendWatchData = DataHelper.dictionaryToObject(objectType: FriendWatch.self, dictionary: data) else {
            print("not friend list")
            if let error = data["errorCode"] as? String, error == "S003" {
                self.isValid = false
            }
            return
        }
        guard let isAdd = friendWatchData.addOrDelete else {
            if let firstIndex = self.friendWatchList.firstIndex(where: { $0.uuid == friendWatchData.uuid }) {
                self.friendWatchList[firstIndex] = friendWatchData
            }
            return
        }
        if isAdd {
            // 친구 추가
            self.friendWatchList.append(friendWatchData)
        } else {
            // 친구 삭제
            if let firstIndex = self.friendWatchList.firstIndex(where: { $0.uuid == friendWatchData.uuid }) {
                self.friendWatchList.remove(at: firstIndex)
            }
        }
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("did disconnect")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("did connect")
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        StatusServiceAPI.shared.connectLogin(uuid: uuid)
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
