//
//  MainCoordinator.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/17.
//

import Foundation
import UIKit

/**
 CustomTabViewController에서 발생하는 이동/전환을 위한 coordinator
 */
class MainCoordinator: NSObject, Coordinator {
    var parentCoordinator: Coordinator?
    var navigation: UINavigationController
    var childCoordinators: [Coordinator] = []

    var homeCoordinator: HomeTabCoordinator?
    var myCoordinator: MyTabCoordinator?
    
    init(parent: Coordinator?, navigation: UINavigationController) {
        self.navigation = navigation
        self.parentCoordinator = parent
    }
    
    func showTabPage() {
        let childCoordinator = MainCoordinator(parent: self, navigation: self.navigation)
        self.childCoordinators.append(childCoordinator)
        guard let tabVC = UIStoryboard(name: "Tab", bundle: nil).instantiateViewController(withIdentifier: "CustomTabViewController") as? CustomTabViewController else { return }
        tabVC.coordinator = childCoordinator
        navigation.pushViewController(tabVC, animated: true)
    }
    
    func addSubTab(tabVC: CustomTabViewController) {
        guard let homeVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? HomeNavigationController, let myVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "MyPageNavigationController") as? MyPageNavigationController else { return }
        tabVC.addChild(homeVC)
        tabVC.homeContainerView.addSubview((homeVC.view)!)
        homeVC.view.frame = tabVC.homeContainerView.bounds
        homeVC.didMove(toParent: tabVC)
        self.homeCoordinator = HomeTabCoordinator(parent: self, navigation: homeVC)
        homeVC.coordinator = homeCoordinator
        tabVC.addChild(myVC)
        tabVC.myContainerView.addSubview((myVC.view)!)
        myVC.view.frame = tabVC.myContainerView.bounds
        myVC.didMove(toParent: tabVC)
        self.myCoordinator = MyTabCoordinator(parent: self, navigation: myVC)
        myVC.coordinator = myCoordinator
    }
    
    func dismissToRoot(){}

    /**
     하단 탭바를 선택할 경우 호출
     
     - 동일한 탭을 연속해서 선택할 경우 해당 탭의 최상단으로 이동
     - 다른 탭에 이동했다가 돌아올 경우, 이전에 쌓였던 뷰가 유지됨
     */
    func changeTab(index: Int, tabVC: CustomTabViewController) {
        switch index {
        case 0:
            self.homeCoordinator?.start()
        case 1:
            guard let popOverVC = UIStoryboard(name: "Create", bundle: nil).instantiateViewController(withIdentifier: "CreateNavigationController") as? CreateNavigationController else { return }
            let childCoordinator = CreateTabCoordinator(parent: self, navigation: popOverVC)
            self.childCoordinators.append(childCoordinator)
            popOverVC.coordinator = childCoordinator
            childCoordinator.start()
        default:
            self.myCoordinator?.start()
        }
    }
}
