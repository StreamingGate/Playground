//
//  MyTabCoordinator.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/17.
//

import Foundation
import UIKit

class MyTabCoordinator: Coordinator {
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
            tabVC.selectedTabIndex = 2
            tabVC.removeChildViewController()
            tabVC.addChild(self.navigation)
            tabVC.containerView.addSubview((self.navigation.view)!)
            self.navigation.view.frame = tabVC.containerView.bounds
            self.navigation.didMove(toParent: tabVC)
        }
    }
    
    func showPlayer() {
        let childCoordinator = PlayerCoordinator(parent: self.parentCoordinator, navigation: self.navigation)
        self.childCoordinators.append(childCoordinator)
        childCoordinator.start(info: nil)
    }
    
    func showVideoList(index: Int) {
        guard let videoListVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "VideoListViewController") as? VideoListViewController else { return }
        videoListVC.type = index
        navigation.pushViewController(videoListVC, animated: true)
    }
    
    func showProfile() {
        guard let accountVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "AccountInfoViewController") as? AccountInfoViewController, let tabVC = self.parentCoordinator?.navigation.viewControllers.last as? CustomTabViewController else { return }
        tabVC.tabBarHeight.constant = 0
        navigation.pushViewController(accountVC, animated: true)
    }
    
    func showChannel() {
        guard let channelVC = UIStoryboard(name: "Channel", bundle: nil).instantiateViewController(withIdentifier: "ChannelViewController") as? ChannelViewController else { return }
        navigation.pushViewController(channelVC, animated: true)
    }
    
    func showAccountEdit() {
        let childCoordinator = AccountEditCoordinator(parent: self, navigation: self.parentCoordinator?.navigation ?? UINavigationController())
        self.childCoordinators.append(childCoordinator)
        childCoordinator.start()
    }
    
    func dismiss() {
        self.navigation.dismiss(animated: true, completion: nil)
    }
    
    func dismissToRoot() {
        self.parentCoordinator?.navigation.popToRootViewController(animated: true)
    }
    
    func pop() {
        guard let tabVC = self.parentCoordinator?.navigation.viewControllers.last as? CustomTabViewController else { return }
        tabVC.tabBarHeight.constant = 80
        self.navigation.popViewController(animated: true)
    }
}
