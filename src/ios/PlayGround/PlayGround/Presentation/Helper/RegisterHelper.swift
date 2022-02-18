//
//  RegisterHelper.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/19.
//

import Foundation
import UIKit

/**
 회원가입 절차 중 생긴 정보를 임시로 가지고 있기 위한 helper
 */
class RegisterHelper {
    static let shared = RegisterHelper()
    
    var name: String?
    var email: String?
    var isVerified: Bool?
    var nickName: String?
    var profileImage: UIImage?
    var password: String?
}
