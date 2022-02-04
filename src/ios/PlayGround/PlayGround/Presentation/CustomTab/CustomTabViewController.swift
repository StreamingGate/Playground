//
//  CustomTabViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/13.
//

import Foundation
import UIKit
import Combine

class CustomTabViewController: UIViewController {
    @IBOutlet weak var playViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var tabBarHeight: NSLayoutConstraint!
    
    @IBOutlet weak var tabBarStackView: UIStackView!
    @IBOutlet weak var playViewHeight: NSLayoutConstraint!
    @IBOutlet weak var playContainerView: UIView!
    @IBOutlet weak var tabBarSeparatorView: UIView!
    @IBOutlet weak var bottomWhiteView: UIView!
    @IBOutlet weak var homeTabImageView: UIImageView!
    @IBOutlet weak var homeTabLabel: UILabel!
    @IBOutlet weak var myTabImageView: UIImageView!
    @IBOutlet weak var CreateTabImageView: UIImageView!
    @IBOutlet weak var myTabLabel: UILabel!
    @IBOutlet weak var homeContainerView: UIView!
    @IBOutlet weak var myContainerView: UIView!
    
    @Published var selectedTabIndex = 0
    private var cancellable: Set<AnyCancellable> = []
    
    var safeTop: CGFloat = 0
    var safeBottom: CGFloat = 0
    
    var coordinator: MainCoordinator?
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        safeTop = self.view.safeAreaInsets.top
        safeBottom = self.view.safeAreaInsets.bottom
        playViewHeight.constant = UIScreen.main.bounds.height - safeTop - safeBottom
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
        coordinator?.addSubTab(tabVC: self)
        coordinator?.changeTab(index: 0, tabVC: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playViewHeight.constant = UIScreen.main.bounds.height - safeTop - safeBottom
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            playViewHeight.constant = UIScreen.main.bounds.width
        } else {
            playViewHeight.constant = UIScreen.main.bounds.height - safeTop - safeBottom
        }
    }
    
    func bindData() {
        $selectedTabIndex.receive(on: RunLoop.main)
            .sink { [weak self] index in
                guard let self = self else { return }
                switch index {
                case 0:
                    // 홈탭
                    self.homeTabImageView.image = UIImage(named: "homeIcon_fill")
                    self.myTabImageView.image = UIImage(named: "my_empty")
                case 2:
                    // 마이탭
                    self.homeTabImageView.image = UIImage(named: "homeIcon_empty")
                    self.myTabImageView.image = UIImage(named: "my_fill")
                default:
                    // 생성탭은 UI 딱히 안 바뀔 예정
                    break
                }
            }.store(in: &cancellable)
    }
    
    func setupUI() {
        homeTabLabel.font = UIFont.caption
        myTabLabel.font = UIFont.caption
    }
    
    @IBAction func homeTabDidTap(_ sender: Any) {
        coordinator?.changeTab(index: 0, tabVC: self)
    }
    
    @IBAction func createTabDidTap(_ sender: Any) {
        coordinator?.changeTab(index: 1, tabVC: self)
    }
    
    @IBAction func myTabDidTap(_ sender: Any) {
        coordinator?.changeTab(index: 2, tabVC: self)
    }
    
    func removeChildViewController(){
        if self.children.count > 0{
            let viewControllers:[UIViewController] = self.children
            for i in viewControllers {
                if (i as? PlayViewController) == nil {                
                    i.willMove(toParent: nil)
                    i.removeFromParent()
                    i.view.removeFromSuperview()
                }
            }
        }
    }
    
    func removePlayer() {
        if self.children.count > 0 {
            let viewControllers:[UIViewController] = self.children
            for i in viewControllers {
                if (i as? PlayViewController) != nil {
                    i.willMove(toParent: nil)
                    i.removeFromParent()
                    i.view.removeFromSuperview()
                }
            }
        }
    }
}
