//
//  MyPageViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/02.
//

import Foundation
import UIKit
import Combine

class MyPageViewController: UIViewController {
    @IBOutlet weak var recentVideoTitleLabel: UILabel!
    // MARK: - Properties
    @IBOutlet weak var viewedVideoLabel: UILabel!
    @IBOutlet weak var likedVideoLabel: UILabel!
    @IBOutlet weak var myVideoLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    var navVC: MyPageNavigationController?
    private var cancellable: Set<AnyCancellable> = []
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? MyPageNavigationController else { return }
        self.navVC = nav
        bindData()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navVC?.coordinator?.resetTabBarHeight()
    }
    
    // MARK: - UI Setting
    func setupUI() {
        recentVideoTitleLabel.font = UIFont.Content
        viewedVideoLabel.font = UIFont.Component
        likedVideoLabel.font = UIFont.Component
        myVideoLabel.font = UIFont.Component
        profileImageView.backgroundColor = UIColor.placeHolder
        profileImageView.layer.cornerRadius = 15
        profileImageView.layer.borderColor = UIColor.placeHolder.cgColor
        profileImageView.layer.borderWidth = 1
    }
    
    // MARK: - Data Binding
    func bindData() {
        UserManager.shared.$userInfo.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] user in
                guard let self = self, let userInfo = user else { return }
                self.profileImageView.downloadImageFrom(link: userInfo.profileImage, contentMode: .scaleAspectFill)
            }.store(in: &cancellable)
    }
    
    // MARK: - Button Action
    @IBAction func viewedVideoButtonDidTap(_ sender: Any) {
        self.navVC?.coordinator?.showVideoList(index: 0)
    }
    
    @IBAction func likedVideoButtonDidTap(_ sender: Any) {
        self.navVC?.coordinator?.showVideoList(index: 1)
    }
    
    @IBAction func myVideoButtonDidTap(_ sender: Any) {
        self.navVC?.coordinator?.showVideoList(index: 2)
    }
    
    @IBAction func profileDidTap(_ sender: Any) {
        self.navVC?.coordinator?.showProfile()
    }
}

// MARK: - Recently Viewed Video List (CollectionView)
extension MyPageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentViewedCell", for: indexPath) as? RecentViewedCell else { return UICollectionViewCell() }
        cell.setupUI()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navVC?.coordinator?.showPlayer()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 139)
    }
}
