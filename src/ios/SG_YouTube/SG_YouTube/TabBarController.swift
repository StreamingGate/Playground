//
//  TabBarController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    
    // MARK: - Tab Selection
    // 생성 버튼을 선택할 경우, tab으로 처리되지 않고 탭 위에 띄워지도록 함
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if (viewController as? CreatePopOverViewController)  != nil {
            guard let popOverVC = UIStoryboard(name: "Create", bundle: nil).instantiateViewController(withIdentifier: "CreatePopOverViewController") as? CreatePopOverViewController else { return false }
//            self.addChild(popOverVC)
//            popOverVC.view.frame = self.view.frame
//            self.view.addSubview(popOverVC.view)
//            popOverVC.didMove(toParent: self)
            popOverVC.modalPresentationStyle = .overFullScreen
            popOverVC.modalTransitionStyle = .crossDissolve
            self.present(popOverVC, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
}



protocol test {
    func dismissTest()
}
