//
//  NetworkResultManager.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/04.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class NetworkResultManager {
    static let shared = NetworkResultManager()
    
    func analyze(result: [String: Any], vc: UIViewController, coordinator: Coordinator?) -> Any? {
        if result["result"] as? String == "success" {
            if let data = result["data"] as? [String: Any], let errorCode = data["errorCode"] as? String {
                DispatchQueue.main.async {
                    vc.simpleAlert(message: ErrorCodeConverter().check(errorCode).rawValue)
                    if let playVC = vc as? PlayViewController {
                        playVC.friendRequestButton.isEnabled = false
                        if errorCode == "F002" {
                            playVC.friendRequestLabel.text = "요청 완료"
                        } else if errorCode == "F003" {
                            playVC.friendRequestLabel.text = "친구"
                        }
                    } else if let channelVC = vc as? ChannelViewController {
                        channelVC.friendRequestButton.isEnabled = false
                        if errorCode == "F002" {
                            channelVC.friendRequestLabel.text = "요청 완료"
                        } else if errorCode == "F003" {
                            channelVC.friendRequestLabel.text = "친구"
                        }
                    }
                }
                return nil
            } else {
                return result["data"]
            }
        } else if result["result"] as? String == "Invalid Token" {
            DispatchQueue.main.async {
                let action = UIAlertAction(title: "확인", style: .default) { _ in
                    StatusManager.shared.disconnectToSocket()
                    KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.accessToken.rawValue)
                    KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.uuid.rawValue)
                    UserManager.shared.userInfo = nil
                    coordinator?.dismissToRoot()
                }
                vc.simpleAlertWithAction(message: "토큰이 만료되어서\n로그인 페이지로 이동합니다", action: action)
            }
            return nil
        } else {
            DispatchQueue.main.async {            
                vc.simpleAlert(message: "오류가 발생했습니다.\n잠시 후 다시 시도해주시기 바랍니다")
            }
            return nil
        }
    }
}
