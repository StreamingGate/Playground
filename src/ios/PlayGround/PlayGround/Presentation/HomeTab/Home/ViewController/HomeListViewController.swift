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
import Lottie
import SkeletonView

class HomeListViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var noticeButton: UIButton!
    @IBOutlet weak var friendButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
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
    var isChangingCategory = false
    let animationView: AnimationView = .init(name: "PgLoading")
    let loadingBackView = UIView()
    
    // MARK: - View LifeCycle
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
        // 해당 화면에서 벗어날 경우, 자동재생이 이뤄지는 플레이어가 멈춰야 함
        self.pausePlayer()
    }

    // MARK: - Data Binding
    func bindViewModel() {
        self.viewModel.$homeList.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] list in
                guard let self = self, list != nil else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.tableView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
                    self.collectionViewHeight.constant = 40
                }
                self.animationView.stopLoading(backView: self.loadingBackView)
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }.store(in: &cancellable)
        self.viewModel.$selectedCategory.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] selected in
                guard let self = self else { return }
                let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
                self.tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray4, secondaryColor: .systemGray5), animation: animation, transition: .none)
                self.viewModel.loadAllList(vc: self, coordinator: self.navVC?.coordinator)
            }.store(in: &cancellable)
    }
    
    // MARK: - UI Setting
    func setupUI() {
        // iOS 14 이전의 경우 Storyboard에서 default 상태로 text를 지워도 Button 글자가 사라지지 않음
        searchButton.setTitle("", for: .normal)
        noticeButton.setTitle("", for: .normal)
        friendButton.setTitle("", for: .normal)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        self.tableView.isSkeletonable = true
        self.tableView.skeletonCornerRadius = 5
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray4, secondaryColor: .systemGray5), animation: animation, transition: .crossDissolve(0.5))
        initRefresh()
    }
    
    // MARK: - Refresh Control
    /**
     상단 pull-down 새로고침을 위한 UIRefreshControl
     */
    func initRefresh() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh:)), for: .valueChanged)
        tableView.refreshControl = refresh
    }
    
    /**
     상단 pull-down 시 새로운 정보를 가져옴
     */
    @objc func updateUI(refresh: UIRefreshControl) {
        refresh.endRefreshing()
        self.pausePlayer()
        self.viewModel.lastLiveId = -1
        self.viewModel.lastVideoId = -1
        self.pausePlayer()
        self.animationView.setLoading(vc: self, backView: self.loadingBackView)
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        tableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray4, secondaryColor: .systemGray5), animation: animation, transition: .none)
        self.viewModel.loadAllList(vc: self, coordinator: self.navVC?.coordinator)
    }
    
    /**
     인피니트 스크롤을 위한 UIRefreshControl을 UITableView Footer에 추가
     */
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        return footerView
    }
    
    // MARK: - Player Control
    /**
     자동재생되는 플레이어 멈춤
     */
    func pausePlayer() {
        self.playerView.player?.pause()
        self.playerView.player?.replaceCurrentItem(with: nil)
        self.playerView.backgroundColor = UIColor.clear
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
        navVC?.coordinator?.showFriendList(vc : self)
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
        self.isChangingCategory = true
        
        self.collectionView.reloadData()
    }
}

// MARK: - Video List (TableView)
extension HomeListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.homeList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as? VideoListCell else { return UITableViewCell() }
        guard let homeList = self.viewModel.homeList else { return cell}
        if let host = homeList[indexPath.row].hostNickname, host != "" {
            cell.setupLive(info: homeList[indexPath.row])
        } else {
            cell.setupVideo(info: homeList[indexPath.row])
        }
        cell.channelTapHandler = {
            self.pausePlayer()
            self.navVC?.coordinator?.showChannel(uuid: homeList[indexPath.row].hostUuid == nil ? homeList[indexPath.row].uploaderUuid ?? "" : homeList[indexPath.row].hostUuid ?? "")
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
        guard let homeList = self.viewModel.homeList else { return }
        self.navVC?.coordinator?.showPlayer(info: homeList[indexPath.row])
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
            self.animationView.setLoading(vc: self, backView: loadingBackView)
            print("here")
            self.tableView.tableFooterView = createSpinnerFooter()
            self.viewModel.loadAllList(vc: self, coordinator: self.navVC?.coordinator)
        } else {
            // 더이상 로드할 데이터가 없을 경우, spinner 멈춤
            self.animationView.stopLoading(backView: loadingBackView)
            self.spinner.stopAnimating()
        }
    }
    
    /**
    스크롤이 멈추면 페이지 중앙의 동영상을 자동 재생
     */
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let parent = self.navigationController?.parent as? CustomTabViewController else { return }
        if parent.children.contains(where: { ($0 as? PlayViewController) != nil }) {
            self.pausePlayer()
            return
        }
        if scrollView == tableView {
            guard let visibleRows = tableView.indexPathsForVisibleRows, let first = visibleRows.first, let last = visibleRows.last else { return }
            let middleIndex = ((first.row) + (last.row)) / 2
            if middle == middleIndex { return }
            self.middle = middleIndex
            self.playerView.player = nil
            let cell = tableView.cellForRow(at: IndexPath(row: middleIndex, section: 0))
            let width = UIScreen.main.bounds.width
            let height = width / 16 * 9
            playerView.frame = CGRect(x: cell?.frame.minX ?? 0, y: cell?.frame.minY ?? 0, width: width, height: height)
            guard let homeList = self.viewModel.homeList, let fileLink = homeList[middleIndex].fileLink, let url = URL(string: fileLink) else { return }
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

extension HomeListViewController: TransitionDelegate {
    func showPlayer(info: GeneralVideo) {
        self.navVC?.coordinator?.showPlayer(info: info)
    }
}

extension HomeListViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "VideoListCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
