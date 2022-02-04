//
//  NetworkResultManager.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/04.
//

import Foundation
import UIKit

class NetworkResultManager {
    static let shared = NetworkResultManager()
    
    func analyze(result: [String: Any], vc: UIViewController) -> Any? {
        if result["result"] as? String == "success" {
            if let data = result["data"] as? [String: Any], let errorCode = data["errorCode"] as? String {
                DispatchQueue.main.async {
                    vc.simpleAlert(message: ErrorCodeConverter().check(errorCode).rawValue)
                }
                return nil
            } else {
                return result["data"]
            }
        } else {
            DispatchQueue.main.async {            
                vc.simpleAlert(message: "오류가 발생했습니다.\n잠시 후 다시 시도해주시기 바랍니다")
            }
            return nil
        }
    }
}
