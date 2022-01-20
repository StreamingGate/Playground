//
//  RegisterHelper.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/19.
//

import Foundation
import UIKit

class RegisterHelper {
    static let shared = RegisterHelper()
    
    var name: String?
    var email: String?
    var isVerified: Bool?
    var nickName: String?
    var profileImage: UIImage?
    var password: String?
}
