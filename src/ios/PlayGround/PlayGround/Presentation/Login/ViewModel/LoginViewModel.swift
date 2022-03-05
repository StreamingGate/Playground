//
//  LoginViewModel.swift
//  PlayGround
//
//  Created by 서채희 on 2022/03/05.
//

import Foundation
import Combine
import SwiftKeychainWrapper

class LoginViewModel {
    
    @Published var isLoginSucceed: Bool?
    var failMessage: String?
    
    func autoLogin(token: String, email: String, uuid: String) {
        UserServiceAPI.shared.autoLogin(accessToken: token, email: email, uuid: uuid) { result in
            if result["success"] as? Int == 1, let userInfo = result["data"] as? UserInfo {
                // KeyChain - uuid와 accessToken 저장 (종료 후에도 유지됨)
                guard let token = userInfo.refreshToken else { return }
                KeychainWrapper.standard.set(token, forKey: KeychainWrapper.Key.accessToken.rawValue)
                UserManager.shared.userInfo = userInfo
                StatusServiceAPI.shared.getFriendInfo { result in
                    guard let friends = result["data"] as? FriendWatchList else { return }
                    StatusManager.shared.friendWatchList = friends.result
                    StatusManager.shared.connectToSocket()
                }
                self.failMessage = nil
                self.isLoginSucceed = true
            } else {
                self.failMessage = "자동 로그인에 실패했습니다"
                self.isLoginSucceed = false
            }
        }
    }
    
    func login(idInfo: String, pwInfo: String) {
        UserServiceAPI.shared.login(email: idInfo, password: pwInfo, timezone: TimeZone.current.identifier, fcmtoken: "token") { result in
            if result["success"] as? Int == 1, let uuid = result["uuid"] as? String, let token = result["accessToken"] as? String, let userInfo = result["data"] as? UserInfo {
                // KeyChain - uuid와 accessToken 저장 (종료 후에도 유지됨)
                // UserManager - 싱글톤으로 userInfo 저장
                KeychainWrapper.standard.set(uuid, forKey: KeychainWrapper.Key.uuid.rawValue)
                KeychainWrapper.standard.set(token, forKey: KeychainWrapper.Key.accessToken.rawValue)
                KeychainWrapper.standard.set(idInfo, forKey: KeychainWrapper.Key.email.rawValue)
                UserManager.shared.userInfo = userInfo
                StatusServiceAPI.shared.getFriendInfo { result in
                    guard let friends = result["data"] as? FriendWatchList else { return }
                    StatusManager.shared.friendWatchList = friends.result
                    StatusManager.shared.connectToSocket()
                }
                self.failMessage = nil
                self.isLoginSucceed = true
            } else {
                DispatchQueue.main.async {
                    self.failMessage = "로그인에 실패했습니다"
                    self.isLoginSucceed = false
                }
            }
        }
    }
}
