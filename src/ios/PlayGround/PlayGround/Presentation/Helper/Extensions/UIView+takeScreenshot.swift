//
//  UIView+takeScreenshot.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/17.
//

import Foundation
import UIKit

extension UIView {
    func takeScreenshot(color: UIColor, character: String) -> UIImage {
        self.snapshotView(afterScreenUpdates: true)
        self.backgroundColor = color
        
        let firstCharacterLabel = UILabel()
        firstCharacterLabel.font = UIFont(name: "Apple SD Gothic Neo", size: 70) ?? UIFont.systemFont(ofSize: 70)
        firstCharacterLabel.textAlignment = .center
        firstCharacterLabel.text = character
        firstCharacterLabel.translatesAutoresizingMaskIntoConstraints = false
        firstCharacterLabel.textColor = UIColor.white
        self.addSubview(firstCharacterLabel)
        NSLayoutConstraint.activate([
            firstCharacterLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            firstCharacterLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            firstCharacterLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 5)
        ])
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()        
        
        if image != nil {
            let imagedata = image!.pngData()!
            let imageInPng = UIImage(data:imagedata,scale:1.0)
            return imageInPng!
        }
        return UIImage()
    }
}
