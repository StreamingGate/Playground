//
//  HomeListViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/28.
//

import Foundation
import UIKit
import AVFoundation
import Combine

class HomeListViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    private var cancellable: Set<AnyCancellable> = []
    var selectedIndex = 0
    var player = AVPlayer()
    let playerView = PlayerView()
    var safeTop: CGFloat = 0
    var safeBottom: CGFloat = 0
    var middle = 0
    var navVC: HomeNavigationController?
    
    let viewModel = HomeViewModel()
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    let categoryDic = ["ALL": "전체", "EDU": "교육", "SPORTS": "스포츠", "KPOP": "K-POP"]
    
    // MARK: - View Life Cycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        safeTop = self.view.safeAreaInsets.top
        safeBottom = self.tabBarController?.tabBar.safeAreaInsets.bottom ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        self.tableView.addSubview(playerView)
        self.playerView.isUserInteractionEnabled = false
        guard let nav = self.navigationController as? HomeNavigationController else{ return }
        self.navVC = nav
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.pausePlayer()
    }

    // MARK: - Data Binding
    func bindViewModel() {
        self.viewModel.$homeList.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] list in
                guard let self = self else { return }
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }.store(in: &cancellable)
        self.viewModel.$selectedCategory.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] selected in
                guard let self = self else { return }
                self.viewModel.loadAllList(vc: self, coordinator: self.navVC?.coordinator)
            }.store(in: &cancellable)
    }
    
    // MARK: - UI Setting
    func setupUI() {
        // iOS 14 이전의 경우 Storyboard에서 default 상태로 text를 지워도 Button 글자가 사라지지 않음
        searchButton.setTitle("", for: .normal)
        noticeButton.setTitle("", for: .normal)
        friendButton.setTitle("", for: .normal)
    }
    
    // 인피니트 스크롤을 위해서 푸터 스피너 추가
    private func createSpinnerFooter() -> UIView {
       let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
       spinner.center = footerView.center
       footerView.addSubview(spinner)
       spinner.startAnimating()
       return footerView
    }
    
    // MARK: - Player Control
    func pausePlayer() {
        self.playerView.player?.pause()
        self.playerView.player?.replaceCurrentItem(with: nil)
        self.playerView.player = nil
    }
    
    // MARK: - Button Action
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
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
        cell.setupUI(selected: selectedIndex == indexPath.item, category: categoryDic[viewModel.categories[indexPath.item]] ?? "기타")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = categoryDic[viewModel.categories[indexPath.item]] ?? "기타"
        let itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.Component
        ])
        let width : CGFloat = itemSize.width + 40
        return  CGSize(width: width, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.item
        if tableView.numberOfRows(inSection: 0) > 0 {        
            self.tableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
        self.viewModel.selectedCategory = viewModel.categories[indexPath.item]
        
        // 카테고리 변경 시, 가장 최신 동영상부터 다시 로드
        self.viewModel.lastLiveId = -1
        self.viewModel.lastVideoId = -1
        
        self.collectionView.reloadData()
    }
}

// MARK: - Video List (TableView)
extension HomeListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.homeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as? VideoListCell else { return UITableViewCell() }
        cell.setupUI(indexPath.row)
        if let host = viewModel.homeList[indexPath.row].hostNickname, host != "" {
            cell.setupLive(info: viewModel.homeList[indexPath.row])
        } else {
            cell.setupVideo(info: viewModel.homeList[indexPath.row])
        }
        
        cell.channelTapHandler = {
            self.pausePlayer()
            self.navVC?.coordinator?.showChannel()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if middle == indexPath.row {
            self.pausePlayer()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.pausePlayer()
        self.navVC?.coordinator?.showPlayer(info: viewModel.homeList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height - scrollView.frame.size.height) && !self.viewModel.isFinished {
            guard !self.viewModel.isLoading else {
                return
            }
            self.tableView.tableFooterView = createSpinnerFooter()
            self.viewModel.loadAllList(vc: self, coordinator: self.navVC?.coordinator)
        } else {
            // 더이상 로드할 데이터가 없을 경우, spinner 멈춤
            self.spinner.stopAnimating()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let parent = self.navigationController?.parent as? CustomTabViewController else { return }
        if parent.children.contains(where: { ($0 as? PlayViewController) != nil }) {
            self.pausePlayer()
            return
        }
        if scrollView == tableView {
            guard let visibleRows = tableView.indexPathsForVisibleRows, let first = visibleRows.first, let last = visibleRows.last else { return }
            let middleIndex = ((first.row) + (last.row))/2
            if middle == middleIndex { return }
            self.middle = middleIndex
            self.playerView.player = nil
            let cell = tableView.cellForRow(at: IndexPath(row: middleIndex, section: 0))
            let width = UIScreen.main.bounds.width
            let height = width / 16 * 9
            playerView.frame = CGRect(x: cell?.frame.minX ?? 0, y: cell?.frame.minY ?? 0, width: width, height: height)
            guard let fileLink = viewModel.homeList[middleIndex].fileLink, let url = URL(string: fileLink) else { return }
            let avAsset = AVURLAsset(url: url)
            let item = AVPlayerItem(asset: avAsset)
            player.replaceCurrentItem(with: item)
            self.playerView.backgroundColor = UIColor.black
            self.playerView.player = player
            self.playerView.player?.play()
            self.playerView.player?.isMuted = true
        }
    }
}
