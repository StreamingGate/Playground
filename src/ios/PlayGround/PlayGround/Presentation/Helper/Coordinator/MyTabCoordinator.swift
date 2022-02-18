//
//  MyTabCoordinator.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/17.
//

import Foundation
import UIKit

/**
 MyPageNavigationController 에서 발생하는 이동/전환을 위한 Coordinator
 */
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
            tabVC.myContainerView.isHidden = false
            tabVC.homeContainerView.isHidden = true
            if tabVC.selectedTabIndex == 2 {
                // 이전에도 동일한 탭이었을 경우, 최상단으로 이동
                self.navigation.popToRootViewController(animated: true)
            } else {
                tabVC.selectedTabIndex = 2
            }
        }
    }
    
    func showPlayer(info: GeneralVideo) {
        let childCoordinator = PlayerCoordinator(parent: self.parentCoordinator, navigation: self.navigation)
        self.childCoordinators.append(childCoordinator)
        childCoordinator.start(info: info)
    }
    
    func showVideoList(index: Int) {
        guard let videoListVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "VideoListViewController") as? VideoListViewController else { return }
        videoListVC.type = index
        navigation.pushViewController(videoListVC, animated: true)
    }
    
    func showProfile() {
        guard let accountVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "AccountInfoViewController") as? AccountInfoViewController else { return }
        navigation.pushViewController(accountVC, animated: true)
    }
    
    func showChannel(uuid: String) {
        guard let channelVC = UIStoryboard(name: "Channel", bundle: nil).instantiateViewController(withIdentifier: "ChannelViewController") as? ChannelViewController else { return }
        channelVC.viewModel.loadChannelInfo(uuid: uuid)
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
        self.navigation.popViewController(animated: true)
    }
}
