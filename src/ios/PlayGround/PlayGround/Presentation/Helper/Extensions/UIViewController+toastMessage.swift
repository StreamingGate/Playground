//
//  UIViewController+toastMessage.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/08.
//

import Foundation
import UIKit

extension UIViewController {
    static func showToastMessage(toastLabel: UILabel, font: UIFont = UIFont.systemFont(ofSize: 12, weight: .light)) {
        let window = UIApplication.shared.windows.first!
        toastLabel.frame = CGRect(x: window.frame.width / 2 - 150, y: window.frame.height - 180, width: 300, height: 50)
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        toastLabel.textColor = UIColor.white
        toastLabel.numberOfLines = 2
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 25
        toastLabel.clipsToBounds = true
        
        guard let topController = UIApplication.shared.keyWindow?.rootViewController else { return }
        topController.view.addSubview(toastLabel)
    }
}
