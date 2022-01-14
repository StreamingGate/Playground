//
//  HomeNavigationController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/14.
//

import Foundation
import UIKit

class HomeNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    var playDelegate: playOpenDelegate?
    var friendDelegate: friendListOpenDelegate?
    var searchDelegate: searchOpenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}
