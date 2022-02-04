//
//  AccountInfoViewModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/04.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import Combine

class AccountInfoViewModel {
    @Published var friendList: [Friend] = []
    
    func loadFriend() {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        MainServiceAPI.shared.loadFriends(uuid: uuid) { result in
            if result["result"] as? String == "success" {
                guard let friendData = result["data"] as? [Friend] else { return }
                self.friendList = friendData
            }
        }
    }
    
    func deleteFriend(friendUuid: String, vc: UIViewController) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        MainServiceAPI.shared.deleteFriend(uuid: uuid, target: friendUuid) { result in
            if NetworkResultManager.shared.analyze(result: result, vc: vc) != nil {
                self.loadFriend()
            }
        }
    }
}
