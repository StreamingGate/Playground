//
//  HomeListViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/28.
//

import Foundation
import UIKit
import AVFoundation

class HomeListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex = 0
    
    let playerView = PlayerView()
    var safeTop: CGFloat = 0
    var safeBottom: CGFloat = 0
    var navVC: HomeNavigationController?
    var middle = 0
    var player = AVPlayer()
    
    // MARK: - View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        safeTop = self.view.safeAreaInsets.top
        safeBottom = self.tabBarController?.tabBar.safeAreaInsets.bottom ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.tableView.addSubview(playerView)
        self.playerView.isUserInteractionEnabled = false
        guard let nav = self.navigationController as? HomeNavigationController else{ return }
        self.navVC = nav
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    func setupUI() {
        searchButton.setTitle("", for: .normal)
        noticeButton.setTitle("", for: .normal)
        friendButton.setTitle("", for: .normal)
    }
    
    @IBAction func noticeButtonDidTap(_ sender: Any) {
        navVC?.coordinator?.showNotice()
    }
    
    @IBAction func searchButtonDidTap(_ sender: Any) {
        navVC?.coordinator?.showSearch()
    }
    
    @IBAction func friendButtonDidTap(_ sender: Any) {
        navVC?.coordinator?.showFriendList()
    }
    
    func removeTopChildViewController(){
        if self.children.count > 0 {
            let viewControllers:[UIViewController] = self.children
            for i in viewControllers {
                i.willMove(toParent: nil)
                i.removeFromParent()
                i.view.removeFromSuperview()
            }
        }
    }
}

// MARK: - Category List (CollectionView)
extension HomeListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        cell.setupUI(selected: selectedIndex == indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = "Label"
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.Component
        ])
        let width : CGFloat = itemSize.width + 30
        return  CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
        self.collectionView.reloadData()
    }
}

// MARK: - Video List (TableView)
extension HomeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as? VideoListCell else { return UITableViewCell() }
        cell.setupUI(indexPath.row, middle)
        cell.channelTapHandler = {
            self.playerView.player?.pause()
            self.playerView.player?.replaceCurrentItem(with: nil)
            self.playerView.player = nil
            self.navVC?.coordinator?.showChannel()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if middle == indexPath.row {
            self.playerView.player?.pause()
            self.playerView.player?.replaceCurrentItem(with: nil)
            self.playerView.player = nil
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.playerView.player?.pause()
        self.playerView.player?.replaceCurrentItem(with: nil)
        self.playerView.player = nil
        self.navVC?.coordinator?.showPlayer()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let parent = self.navigationController?.parent as? CustomTabViewController else { return }
        if parent.children.contains(where: { ($0 as? PlayViewController) != nil }) {
            self.playerView.player = nil
            return
        }
        if scrollView == tableView {
            let middleIndex = ((tableView.indexPathsForVisibleRows?.first?.row)! + (tableView.indexPathsForVisibleRows?.last?.row)!)/2
            if middle == middleIndex { return }
            self.middle = middleIndex
            self.playerView.player = nil
            let cell = tableView.cellForRow(at: IndexPath(row: middleIndex, section: 0))
            let width = UIScreen.main.bounds.width
            let height = width / 16 * 9
            playerView.frame = CGRect(x: cell?.frame.minX ?? 0, y: cell?.frame.minY ?? 0, width: width, height: height)
            let url = URL(string: "https://bitmovin-a.akamaihd.net/content/art-of-motion_drm/m3u8s/11331.m3u8")!
            let avAsset = AVURLAsset(url: url)
            let item = AVPlayerItem(asset: avAsset)
            player.replaceCurrentItem(with: item)
            self.playerView.player = player
            self.playerView.player?.play()
        }
    }
}
