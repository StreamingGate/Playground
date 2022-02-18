//
//  FriendViewModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/04.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import Combine

class FriendViewModel {
    @Published var friendList: [Friend] = []
    var currentFriend: FriendWatch?
    
    func loadFriend(vc: UIViewController, coordinator: Coordinator?) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        MainServiceAPI.shared.loadFriends(uuid: uuid) { result in
            if let friendData = NetworkResultManager.shared.analyze(result: result, vc: vc, coordinator: coordinator) as? [Friend] {
                self.friendList = friendData
            }
        }
    }
}
