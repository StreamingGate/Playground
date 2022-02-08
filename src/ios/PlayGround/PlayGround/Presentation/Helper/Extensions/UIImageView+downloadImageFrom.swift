//
//  UIImageView+downloadImageFrom.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/31.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImageFrom(link: String, contentMode: UIView.ContentMode) {
        URLSession.shared.dataTask(with: URL(string:link)!, completionHandler: {
            (data, response, error) -> Void in
            DispatchQueue.main.async {
                self.contentMode =  contentMode
                if let data = data { self.image = UIImage(data: data) }
            }
        }).resume()
    }
}
