//
//  SceneDelegate.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/28.
//

import UIKit
import SafariServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("disconnected")
        guard let root = window?.rootViewController as? LoginNavigationController, let tabBar = root.viewControllers.last as? CustomTabViewController else { return }
        if let player = tabBar.children.last as? PlayViewController, let chatting = player.children.last(where: { ($0 as? ChattingViewController) != nil }) as? ChattingViewController {
            print("Viewer chat disconnected")
            chatting.viewModel.disconnectToSocket()
        } else if let createNav = tabBar.presentedViewController as? CreateNavigationController, let liveVC = createNav.viewControllers.last as? LiveViewController {
            print("Streamer chat disconnected")
            liveVC.viewModel.disconnectToSocket()
        }
        StatusManager.shared.disconnectToSocket()
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        StatusServiceAPI.shared.getFriendInfo { result in
            guard let friends = result["data"] as? FriendWatchList else { return }
            StatusManager.shared.friendWatchList = friends.result
            StatusManager.shared.connectToSocket()
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("background")
        StatusManager.shared.disconnectToSocket()
    }


    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if url.absoluteString.starts(with: "playground://producerClose") {
                print("access")
                SFSafariViewController.shared.view.removeFromSuperview()
                guard let root = window?.rootViewController as? LoginNavigationController, let tabBar = root.viewControllers.last as? CustomTabViewController, let createNav = tabBar.presentedViewController as? CreateNavigationController, let liveVC = createNav.viewControllers.last as? LiveViewController else { return }
                liveVC.setupUIforClose()
            }
        }
    }
}

