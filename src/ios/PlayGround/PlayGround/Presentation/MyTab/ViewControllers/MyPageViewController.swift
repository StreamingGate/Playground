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
    @IBOutlet weak var collectionView: UICollectionView!
    var navVC: MyPageNavigationController?
    private var cancellable: Set<AnyCancellable> = []
    let viewModel = MyPageViewModel()
    
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
        self.viewModel.loadWachedList(vc: self, coordinator: navVC?.coordinator)
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
        self.viewModel.$myList.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] list in
                guard let self = self else { return }
                if list.count == 0 {
                    self.collectionViewHeight.constant = 0
                } else {
                    self.collectionViewHeight.constant = 139
                }
                self.collectionView.reloadData()
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
        return self.viewModel.myList.count >= 10 ? 10 : self.viewModel.myList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentViewedCell", for: indexPath) as? RecentViewedCell else { return UICollectionViewCell() }
        if self.viewModel.myList[indexPath.item].uploaderNickname == nil {
            cell.setupLive(info: self.viewModel.myList[indexPath.item])
        } else {
            cell.setupVideo(info: self.viewModel.myList[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navVC?.coordinator?.showPlayer(info: self.viewModel.myList[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 139)
    }
}
