//
//  MyPageNavigationController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit

class MyPageNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    var playDelegate: playOpenDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
}
