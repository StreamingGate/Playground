////
////  Coordinator.swift
////  PlayGround
////
////  Created by chuiseo-MN on 2022/01/16.
////
//
import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var parentCoordinator: Coordinator? { get set }
    var childCoordinators: [Coordinator] { get set }
    var navigation: UINavigationController { get set }
    func dismissToRoot()
//    func start()
}
