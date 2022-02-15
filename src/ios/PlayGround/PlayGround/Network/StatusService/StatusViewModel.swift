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

class StatusViewModel{
    static let shared = StatusViewModel()
    
    @Published var friendWatchList: [FriendWatch] = []
    
    func connectToSocket() {
        StatusServiceAPI.shared.connectToSocket(viewModel: self)
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

extension StatusViewModel: StompClientLibDelegate {
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        print("did receive \(jsonBody)")
        guard let data = jsonBody as? [String: Any], let friendWatchData = DataHelper.dictionaryToObject(objectType: FriendWatch.self, dictionary: data) else {
            print("cannot unwrap")
            return
        }
        if let firstIndex = self.friendWatchList.firstIndex(where: { $0.uuid == friendWatchData.uuid }) {
            self.friendWatchList[firstIndex] = friendWatchData
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
