//
//  UserManager.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/19.
//

import Foundation
import UIKit
import Combine

class UserManager {
    static let shared = UserManager()
    
    @Published var userInfo: UserInfo?
}
