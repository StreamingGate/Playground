//
//  CreateNavigationController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/12.
//

import Foundation
import UIKit

class CreateNavigationController: UINavigationController {
    var coordinator: CreateTabCoordinator?
    var roomUuid = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
