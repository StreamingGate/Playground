//
//  AccountEditCoordinator.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/17.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

/**
 AccountEditViewController에서 발생하는 이동/전환을 위한 Coordinator
 */
class AccountEditCoordinator: Coordinator {
    var parentCoordinator: Coordinator?
    var navigation: UINavigationController
    var childCoordinators: [Coordinator] = []
    var presentViewController: UIViewController?
    
    init(parent: Coordinator?, navigation: UINavigationController) {
        self.navigation = navigation
        self.parentCoordinator = parent
    }

    func start() {
        DispatchQueue.main.async {
            guard let editVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "AccountEditViewController") as? AccountEditViewController else { return }
            self.presentViewController = editVC
            editVC.coordinator = self
            editVC.modalPresentationStyle = .fullScreen
            self.parentCoordinator?.navigation.viewControllers.last?.present(editVC, animated: true, completion: nil)
        }
    }
    
    func dismiss() {
        presentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func dismissToRoot() {
        presentViewController?.dismiss(animated: true, completion: {
            StatusManager.shared.disconnectToSocket()
            KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.accessToken.rawValue)
            KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.uuid.rawValue)
            UserManager.shared.userInfo = nil
            self.navigation.popToRootViewController(animated: true)
        })
    }
}
