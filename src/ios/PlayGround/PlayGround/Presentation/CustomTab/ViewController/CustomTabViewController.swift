//
//  CustomTabViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/13.
//

import Foundation
import UIKit
import Combine


/**
UITabBarController를 사용하지 않고 커스텀 탭바 제작
 
제작 이유 : 자유로운 소형 플레이어 구현을 위해서
 
       - 전체 화면 플레이어는 하단 탭바보다 위에(하단 탭바가 보이지 않게) 위치해야 함
       - 제스처를 통해서 위 플레이어를 소형 플레이어로 전환할 경우, 하단 탭바가 보이고 그 위에 소형 플레이어가 위치해야 함
       - 소형 플레이어는 탭을 전환하여도 플레이가 멈추지 않아야 함
 */
class CustomTabViewController: UIViewController {
    // MARK: - Properties
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
    
    let viewModel = CustomTabViewModel()
    private var cancellable: Set<AnyCancellable> = []
    
    var safeTop: CGFloat = 0
    var safeBottom: CGFloat = 0
    
    var coordinator: MainCoordinator?
    
    // MARK: - View LifeCycle
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        safeTop = self.view.safeAreaInsets.top
        safeBottom = self.view.safeAreaInsets.bottom
        playViewHeight.constant = UIScreen.main.bounds.height - safeTop - safeBottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coordinator?.addSubTab(tabVC: self)
        setupUI()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        playViewHeight.constant = UIScreen.main.bounds.height - safeTop - safeBottom
    }
    
    
    func setupUI() {
        homeTabLabel.font = UIFont.caption
        myTabLabel.font = UIFont.caption
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // 플레이어는 최대화하였을 때, landscape 모드여야 함
        if UIDevice.current.orientation.isLandscape {
            playViewHeight.constant = UIScreen.main.bounds.width
        } else {
            playViewHeight.constant = UIScreen.main.bounds.height - safeTop - safeBottom
        }
    }
    
    func bindData() {
        viewModel.$selectedTabIndex.receive(on: RunLoop.main)
            .sink { [weak self] index in
                guard let self = self else { return }
                switch index {
                case 0:
                    // 홈탭
                    self.homeTabImageView.image = UIImage(named: "homeIcon_fill")
                    self.myTabImageView.image = UIImage(named: "my_empty")
                    self.coordinator?.changeTab(index: 0, tabVC: self)
                case 2:
                    // 마이탭
                    self.homeTabImageView.image = UIImage(named: "homeIcon_empty")
                    self.myTabImageView.image = UIImage(named: "my_fill")
                    self.coordinator?.changeTab(index: 2, tabVC: self)
                default:
                    // 생성 버튼
                    self.coordinator?.changeTab(index: 1, tabVC: self)
                    break
                }
            }.store(in: &cancellable)
    }
    
    @IBAction func homeTabDidTap(_ sender: Any) {
        viewModel.selectedTabIndex = 0
    }
    
    @IBAction func createTabDidTap(_ sender: Any) {
        viewModel.selectedTabIndex = 1
    }
    
    @IBAction func myTabDidTap(_ sender: Any) {
        viewModel.selectedTabIndex = 2
    }
    
    // 플레이어 해제
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
