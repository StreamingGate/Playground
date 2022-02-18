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
        } else if error == "U005" {
            return errorCode.U005
        } else {
            return errorCode.F002
        }
    }
    
    func check(_ error: String) -> errorCode {
        if error == "U001" {
            return errorCode.U001
        } else if error == "U002" {
            return errorCode.U002
        } else if error == "U003" {
            return errorCode.U003
        } else if error == "U004" {
            return errorCode.U004
        } else if error == "U005" {
            return errorCode.U005
        } else if error == "F002" {
            return errorCode.F002
        } else if error == "F003" {
            return errorCode.F003
        } else {
            return errorCode.defaultError
        }
    }
}

enum errorCode: String {
    case U001 = "이미 존재하는 회원입니다"
    case U002 = "존재하지 않는 회원입니다"
    case U003 = "인증코드가 틀렸습니다"
    case U004 = "이미 사용중인 닉네임 입니다"
    case U005 = "회원정보가 올바르지 않습니다"
    case U006 = "이미지를 찾을수 없습니다"
    case V001 = "존재하지 않는 일반 영상입니다"
    case F001 = "해당 유저로부터 받은 친구 요청이 존재하지 않습니다"
    case F002 = "이미 해당 유저에게 친구 신청을 보냈습니다"
    case F003 = "이미 친구인 유저입니다"
    case F004 = "친구가 아닌 유저입니다"
    case L001 = "존재하지 않는 실시간 스트리밍입니다"
    case L002 = "방을 생성할수 없습니다"
    case defaultError = "오류가 발생했습니다"
}
