//
//  HomeTabCoordinator.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/17.
//

import Foundation
import UIKit

class HomeTabCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigation: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(parent: Coordinator?, navigation: UINavigationController) {
        self.navigation = navigation
        self.parentCoordinator = parent
    }

    func start() {
        DispatchQueue.main.async {
            guard let tabVC = self.parentCoordinator?.navigation.viewControllers.last as? CustomTabViewController else { return }
            tabVC.selectedTabIndex = 0
            tabVC.removeChildViewController()
            tabVC.addChild(self.navigation)
            tabVC.containerView.addSubview((self.navigation.view)!)
            self.navigation.view.frame = tabVC.containerView.bounds
            self.navigation.didMove(toParent: tabVC)
        }
    }
    
    func showPlayer(info: GeneralVideo?) {
        let childCoordinator = PlayerCoordinator(parent: self.parentCoordinator, navigation: self.navigation)
        self.childCoordinators.append(childCoordinator)
        childCoordinator.start(info: info)
    }
    
    func showSearch() {
        guard let searchVC = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController" ) as? SearchViewController else { return }
        navigation.pushViewController(searchVC, animated: true)
    }
    
    func showFriendList() {
        guard let popOverVC = UIStoryboard(name: "Friend", bundle: nil).instantiateViewController(withIdentifier: "FriendListViewController" ) as? FriendListViewController else { return }
        popOverVC.modalPresentationStyle = .overFullScreen
        popOverVC.modalTransitionStyle = .crossDissolve
        parentCoordinator?.navigation.viewControllers.last?.present(popOverVC, animated: true, completion: nil)
    }
    
    func showNotice() {
        guard let noticeVC = UIStoryboard(name: "Notice", bundle: nil).instantiateViewController(withIdentifier: "NoticeListViewController") as? NoticeListViewController else { return }
        navigation.pushViewController(noticeVC, animated: true)
    }
    
    func showChannel() {
        guard let channelVC = UIStoryboard(name: "Channel", bundle: nil).instantiateViewController(withIdentifier: "ChannelViewController") as? ChannelViewController else { return }
        navigation.pushViewController(channelVC, animated: true)
    }
    
    func dismiss() {
        self.navigation.dismiss(animated: true, completion: nil)
    }
    
    func pop() {
        self.navigation.popViewController(animated: true)
    }
}
