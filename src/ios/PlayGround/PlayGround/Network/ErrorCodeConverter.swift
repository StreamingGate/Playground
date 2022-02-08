//
//  ErrorCodeConverter.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/19.
//

import Foundation
import UIKit

class ErrorCodeConverter {
    func parse(_ result: [String: Any]) -> errorCode {
        let error = result["errorCode"] as? String
        if error == "U001" {
            return errorCode.U001
        } else if error == "U002" {
            return errorCode.U002
        } else if error == "U003" {
            return errorCode.U003
        } else if error == "U004" {
            return errorCode.U004
        } else {
            return errorCode.U005
        }
    }
}

enum errorCode: String {
    case U001 = "이미 존재하는 회원입니다"
    case U002 = "존재하지 않는 회원입니다"
    case U003 = "인증코드가 틀렸습니다"
    case U004 = "이미 사용중인 닉네임 입니다"
    case U005 = "회원정보가 올바르지 않습니다"
}
