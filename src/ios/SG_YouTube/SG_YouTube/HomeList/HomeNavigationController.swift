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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}
