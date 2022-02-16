//
//  SFSafariViewController+shared.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/14.
//

import Foundation
import UIKit
import SafariServices

extension SFSafariViewController {
    static var shared = SFSafariViewController(url: URL(string: "https://streaminggate.shop")!)
}
