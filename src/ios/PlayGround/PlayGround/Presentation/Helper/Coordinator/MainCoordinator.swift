//
//  MainCoordinator.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/17.
//

import Foundation
import UIKit

class MainCoordinator: NSObject, Coordinator {
    var parentCoordinator: Coordinator?
    var navigation: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(parent: Coordinator?, navigation: UINavigationController) {
        self.navigation = navigation
        self.parentCoordinator = parent
    }

    func start() {
    }

    func showTabPage() {
        let childCoordinator = MainCoordinator(parent: self, navigation: self.navigation)
        self.childCoordinators.append(childCoordinator)
        guard let tabVC = UIStoryboard(name: "Tab", bundle: nil).instantiateViewController(withIdentifier: "CustomTabViewController") as? CustomTabViewController else { return }
        tabVC.coordinator = childCoordinator
        navigation.pushViewController(tabVC, animated: true)
    }



    func changeTab(index: Int, tabVC: CustomTabViewController) {
        switch index {
        case 0:
            guard let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? HomeNavigationController else { return }
            let childCoordinator = HomeTabCoordinator(parent: self, navigation: homeVC)
            self.childCoordinators.append(childCoordinator)
            homeVC.coordinator = childCoordinator
            childCoordinator.start()
        case 1:
            guard let popOverVC = UIStoryboard(name: "Create", bundle: nil).instantiateViewController(withIdentifier: "CreateNavigationController") as? CreateNavigationController else { return }
            let childCoordinator = CreateTabCoordinator(parent: self, navigation: popOverVC)
            self.childCoordinators.append(childCoordinator)
            popOverVC.coordinator = childCoordinator
            childCoordinator.start()
        default:
            guard let myVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "MyPageNavigationController") as? MyPageNavigationController else { return }
            let childCoordinator = MyTabCoordinator(parent: self, navigation: myVC)
            self.childCoordinators.append(childCoordinator)
            myVC.coordinator = childCoordinator
            childCoordinator.start()
        }
    }
}
