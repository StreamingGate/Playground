//
//  PlayerCoordinator.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/17.
//

import Foundation
import UIKit

class PlayerCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigation: UINavigationController
    var childCoordinators: [Coordinator] = []

    init(parent: Coordinator?, navigation: UINavigationController) {
        self.navigation = navigation
        self.parentCoordinator = parent
    }

    func start(info: GeneralVideo?) {
        DispatchQueue.main.async {
            guard let mainVC = self.parentCoordinator?.navigation.viewControllers.last as? CustomTabViewController else { return }
            mainVC.playContainerView.isHidden = false
            if let playVC = mainVC.children.first(where: { vc in
                vc is PlayViewController
            }) as? PlayViewController {
                print("exist")
                playVC.isMinimized = false
                mainVC.playViewTopMargin.constant = 0
                mainVC.tabBarHeight.constant = 0
                mainVC.tabBarStackView.isHidden = true
                mainVC.tabBarSeparatorView.isHidden = true
                mainVC.bottomWhiteView.isHidden = true
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                    mainVC.view.layoutIfNeeded()
                    mainVC.view.backgroundColor = UIColor.black
                }
            } else {
                print("new")
                guard let playVC = UIStoryboard(name: "Play", bundle: nil).instantiateViewController(withIdentifier: "PlayViewController" ) as? PlayViewController else { return }
                playVC.coordinator = self
                mainVC.addChild(playVC)
                playVC.viewModel.currentInfo = info
                mainVC.playContainerView.addSubview((playVC.view)!)
                playVC.view.frame = mainVC.playContainerView.bounds
                playVC.didMove(toParent: mainVC)
                playVC.safeTop = mainVC.safeTop
                playVC.safeBottom = mainVC.safeBottom
                mainVC.tabBarHeight.constant = 0
                mainVC.tabBarStackView.isHidden = true
                mainVC.tabBarSeparatorView.isHidden = true
                mainVC.bottomWhiteView.isHidden = true
            }
        }
    }
    
    func closeMiniPlayer(vc: PlayViewController) {
        guard let parent = self.parentCoordinator?.navigation.viewControllers.last as? CustomTabViewController else { return }
        let targetY = (UIScreen.main.bounds.height)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            vc.view.center = CGPoint(x: vc.view.frame.width / 2, y: (vc.view.frame.height / 2) + targetY)
        } completion: { _ in
            parent.playContainerView.isHidden = true
            parent.playViewTopMargin.constant = 0
            parent.removePlayer()
            vc.view.removeFromSuperview()
        }
    }
    
    func setPlayMinimizing(vc: PlayViewController) {
        guard let parent = self.parentCoordinator?.navigation.viewControllers.last as? CustomTabViewController else { return }
        vc.isMinimized = true
        let maxHeight = UIScreen.main.bounds.height - vc.safeTop - vc.safeBottom - 150
        let targetWidth =  80 / 9 * 16
        vc.playViewWidth.constant = CGFloat(targetWidth)
        vc.miniCloseButton.isHidden = false
        vc.miniPlayPauseButton.isHidden = false
        parent.playViewTopMargin.constant = maxHeight
        parent.tabBarHeight.constant = 80
        parent.tabBarStackView.isHidden = false
        parent.tabBarSeparatorView.isHidden = false
        parent.bottomWhiteView.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            vc.view.backgroundColor = UIColor.clear
            parent.view.backgroundColor = UIColor.white
            parent.view.layoutIfNeeded()
        }
    }
    
    func setPlayViewOriginalSize(vc: PlayViewController) {
        guard let parent = self.parentCoordinator?.navigation.viewControllers.last as? CustomTabViewController else { return }
        vc.isMinimized = false
        vc.playViewWidth.constant = UIScreen.main.bounds.width
        vc.miniCloseButton.isHidden = true
        vc.miniPlayPauseButton.isHidden = true
        parent.playViewTopMargin.constant = 0
        parent.tabBarHeight.constant = 0
        parent.tabBarStackView.isHidden = true
        parent.tabBarSeparatorView.isHidden = true
        parent.bottomWhiteView.isHidden = true
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
            vc.view.backgroundColor = UIColor.clear
            parent.view.backgroundColor = UIColor.black
            parent.view.layoutIfNeeded()
        }
    }
    
    func showExplain(vc: PlayViewController) {
        guard let explainVC = UIStoryboard(name: "Play", bundle: nil).instantiateViewController(withIdentifier: "PlayExplainViewController") as? PlayExplainViewController else { return }
        explainVC.viewModel.currentInfo = vc.viewModel.currentInfo
        vc.addChild(explainVC)
        vc.explainContainerView.addSubview((explainVC.view)!)
        explainVC.view.frame = vc.explainContainerView.bounds
        explainVC.didMove(toParent: vc)
    }
    
    func showChannel() {
        guard let channelVC = UIStoryboard(name: "Channel", bundle: nil).instantiateViewController(withIdentifier: "ChannelViewController") as? ChannelViewController else { return }
        navigation.pushViewController(channelVC, animated: true)
    }
    
    func dismissExplain(vc: PlayViewController) {
        if vc.children.count > 0 {
            let viewControllers:[UIViewController] = vc.children
            for i in viewControllers {
                if (i as? PlayExplainViewController) != nil {
                    vc.explainContainerView.alpha = 0
                    i.willMove(toParent: nil)
                    i.removeFromParent()
                    i.view.removeFromSuperview()
                    return
                }
            }
        }
    }
}
