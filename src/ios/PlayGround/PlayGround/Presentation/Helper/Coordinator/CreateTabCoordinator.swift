//
//  CreateTabCoordinator.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/17.
//

import Foundation
import UIKit

class CreateTabCoordinator: Coordinator {
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
            tabVC.selectedTabIndex = 1
            self.navigation.modalPresentationStyle = .overFullScreen
            self.navigation.modalTransitionStyle = .crossDissolve
            tabVC.present(self.navigation, animated: true, completion: nil)
        }
    }
    
    func showCreatingPage() {
        guard let liveInfoVC = UIStoryboard(name: "Create", bundle: nil).instantiateViewController(withIdentifier: "createInfoViewController") as? createInfoViewController else { return }
        var viewControllers = navigation.viewControllers
        viewControllers[viewControllers.count - 1] = liveInfoVC
        navigation.setViewControllers(viewControllers, animated: true)
    }
    
    func showUploadPage() {
        guard let vc = UIStoryboard(name: "Upload", bundle: nil).instantiateViewController(withIdentifier: "UploadViewController") as? UploadViewController else { return }
        var viewControllers = navigation.viewControllers
        viewControllers[viewControllers.count - 1] = vc
        navigation.setViewControllers(viewControllers, animated: true)
    }
    
    func startBroadcasting() {
        guard let vc = UIStoryboard(name: "Broadcast", bundle: nil).instantiateViewController(withIdentifier: "LiveViewController") as? LiveViewController else { return }
        var viewControllers = navigation.viewControllers
        viewControllers[viewControllers.count - 1] = vc
        navigation.setViewControllers(viewControllers, animated: true)
    }
    
    func dismiss() {
        self.navigation.dismiss(animated: true, completion: nil)
    }
}
