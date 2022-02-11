//
//  HomeTabCoordinator.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/17.
//

import Foundation
import UIKit

/**
 HomeNavigationConroller에서 발생하는 이동/전환을 위한 Coordinator
 */
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
            tabVC.homeContainerView.isHidden = false
            tabVC.myContainerView.isHidden = true
            if tabVC.selectedTabIndex == 0 {
                // 이전에도 동일한 탭이었을 경우, 최상단으로 이동
                self.navigation.popToRootViewController(animated: true)
            } else {
                tabVC.selectedTabIndex = 0
            }
        }
    }
    
    func dismissToRoot() {
        self.parentCoordinator?.navigation.popToRootViewController(animated: true)
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
