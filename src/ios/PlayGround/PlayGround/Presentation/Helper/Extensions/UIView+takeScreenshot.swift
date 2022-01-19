//
//  UIView+takeScreenshot.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/17.
//

import Foundation
import UIKit

extension UIView {
    func takeScreenshot() -> UIImage {
        self.snapshotView(afterScreenUpdates: true)
        self.backgroundColor = UIColor.white
        
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.backgroundColor = UIColor.clear
        
        if image != nil {
            let imagedata = image!.pngData()!
            let imageInPng = UIImage(data:imagedata,scale:1.0)
            return imageInPng!
        }
        return UIImage()
    }
}
