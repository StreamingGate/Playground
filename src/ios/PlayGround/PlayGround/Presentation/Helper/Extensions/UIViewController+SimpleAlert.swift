//
//  UIViewController+SimpleAlert.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/20.
//

import Foundation
import UIKit

extension UIViewController {
    func simpleAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}
