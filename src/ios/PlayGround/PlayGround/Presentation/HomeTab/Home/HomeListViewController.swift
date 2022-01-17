//
//  HomeListViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/28.
//

import Foundation
import UIKit

class HomeListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex = 0
    
    let playerView = UIView()
    var safeTop: CGFloat = 0
    var safeBottom: CGFloat = 0
    var navVC: HomeNavigationController?
    
    // MARK: - View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        safeTop = self.view.safeAreaInsets.top
        safeBottom = self.tabBarController?.tabBar.safeAreaInsets.bottom ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? HomeNavigationController else{ return }
        self.navVC = nav
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
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
        if self.children.count > 0{
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
        cell.setupUI(indexPath.row)
        cell.channelTapHandler = {
            self.navVC?.coordinator?.showChannel()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navVC?.coordinator?.showPlayer()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tableView {
            let middleIndex = ((tableView.indexPathsForVisibleRows?.first?.row)! + (tableView.indexPathsForVisibleRows?.last?.row)!)/2
        }
    }
}
