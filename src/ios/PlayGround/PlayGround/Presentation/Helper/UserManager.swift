//
//  UserManager.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/19.
//

import Foundation
import UIKit
import Combine

/**
 로그인 시 내려오는 UserInfo를 앱 전반에 걸쳐 사용하기 위한 Manager
 */
class UserManager {
    static let shared = UserManager()
    
    @Published var userInfo: UserInfo?
}
