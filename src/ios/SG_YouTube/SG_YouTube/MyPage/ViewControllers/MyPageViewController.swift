//
//  MyPageViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/02.
//

import Foundation
import UIKit

class MyPageViewController: UIViewController {
    @IBOutlet weak var recentVideoTitleLabel: UILabel!
    @IBOutlet weak var viewedVideoLabel: UILabel!
    @IBOutlet weak var likedVideoLabel: UILabel!
    @IBOutlet weak var myVideoLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    // MARK: - UI Setting
    func setupUI() {
        recentVideoTitleLabel.font = UIFont.Content
        viewedVideoLabel.font = UIFont.Component
        likedVideoLabel.font = UIFont.Component
        myVideoLabel.font = UIFont.Component
        profileImageView.backgroundColor = UIColor.placeHolder
        profileImageView.layer.cornerRadius = 10
    }
    
    // MARK: - Button Action
    @IBAction func viewedVideoButtonDidTap(_ sender: Any) {
        guard let videoListVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "VideoListViewController") as? VideoListViewController else { return }
        videoListVC.type = 0
        self.navigationController?.pushViewController(videoListVC, animated: true)
    }
    
    @IBAction func likedVideoButtonDidTap(_ sender: Any) {
        guard let videoListVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "VideoListViewController") as? VideoListViewController else { return }
        videoListVC.type = 1
        self.navigationController?.pushViewController(videoListVC, animated: true)
    }
    
    @IBAction func myVideoButtonDidTap(_ sender: Any) {
        guard let videoListVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "VideoListViewController") as? VideoListViewController else { return }
        videoListVC.type = 2
        self.navigationController?.pushViewController(videoListVC, animated: true)
    }
    
    @IBAction func profileDidTap(_ sender: Any) {
        guard let accountVC = UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: "AccountInfoViewController") as? AccountInfoViewController else { return }
        accountVC.modalPresentationStyle = .fullScreen
        self.present(accountVC, animated: true, completion: nil)
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
        if let playVC = self.children.last as? PlayViewController {
            self.tabBarController?.setTabBar(hidden: true, animated: true, along: self.parent?.transitionCoordinator)
            playVC.isMinimized = false
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                playVC.playViewWidth.constant = UIScreen.main.bounds.width
                playVC.view.backgroundColor = UIColor.black.withAlphaComponent(1)
                playVC.view.center = CGPoint(x: playVC.view.frame.width / 2, y: playVC.view.frame.height / 2)
            }
        } else {
            guard let playVC = UIStoryboard(name: "Play", bundle: nil).instantiateViewController(withIdentifier: "PlayViewController" ) as? PlayViewController else { return }
            self.tabBarController?.setTabBar(hidden: true, animated: true, along: self.transitionCoordinator)
            self.addChild(playVC)
            self.view.addSubview((playVC.view)!)
            playVC.view.frame = self.view.bounds
            playVC.didMove(toParent: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 138, height: 139)
    }
}
