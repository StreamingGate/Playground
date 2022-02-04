//
//  NoticeViewModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/04.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import Combine

class NoticeViewModel {
    @Published var noticeList: [Notice] = []
    @Published var friendRequestList: [Friend] = []
    
    func loadNotice(vc: UIViewController) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        MainServiceAPI.shared.loadNotifications(uuid: uuid) { result in
            if let noticeData = NetworkResultManager.shared.analyze(result: result, vc: vc) as? [Notice] {
                self.noticeList = noticeData
            }
        }
    }
    
    func loadFriendRequest(vc: UIViewController) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        MainServiceAPI.shared.loadFriendRequests(uuid: uuid) { result in
            if let requestData = NetworkResultManager.shared.analyze(result: result, vc: vc) as? [Friend] {
                self.friendRequestList = requestData
            }
        }
    }
    
    func answerFriendRequest(vc: UIViewController, action: Int, friendUuid: String) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        if action == 0 {
            // 거절
            MainServiceAPI.shared.deleteFriendRequest(friendUUID: friendUuid, myUUID: uuid) { result in
                if NetworkResultManager.shared.analyze(result: result, vc: vc) != nil {
                    self.loadFriendRequest(vc: vc)
                }
            }
        } else {
            // 수락
            MainServiceAPI.shared.acceptFriendRequest(friendUUID: friendUuid, myUUID: uuid) { result in
                if NetworkResultManager.shared.analyze(result: result, vc: vc) != nil {
                    self.loadFriendRequest(vc: vc)
                }
            }
        }
    }
    
    func updateViewModel(vm: NoticeViewModel) {
        self.noticeList = vm.noticeList
        self.friendRequestList = vm.friendRequestList
    }
}
