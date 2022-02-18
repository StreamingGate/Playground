//
//  ChannelViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/10.
//

import Foundation
import UIKit
import Combine
import SwiftKeychainWrapper
import Lottie
import SkeletonView

class ChannelViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var channelNameTitleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var channelTitleLabel: UILabel!
    @IBOutlet weak var friendRequestLabel: UILabel!
    @IBOutlet weak var friendRequestButton: UIButton!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var videoTableView: UITableView!
    @IBOutlet weak var videoTableViewHeight: NSLayoutConstraint!
    private var cancellable: Set<AnyCancellable> = []
    let viewModel = ChannelViewModel()
    var navVC: HomeNavigationController?
    let spinner = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
//    let animationView: AnimationView = .init(name: "PgLoading")
//    let loadingBackView = UIView()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.animationView.setLoading(vc: self, backView: loadingBackView)
        videoTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        setupUI()
        bindViewModel()
        guard let navVC = self.navigationController as? HomeNavigationController else{ return }
        self.navVC = navVC
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        videoTableView.removeObserver(self, forKeyPath: "contentSize")
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
    
    // MARK: - UI Setting
    func setupUI() {
        profileImageView.layer.cornerRadius = 25
        profileImageView.backgroundColor = UIColor.placeHolder
        channelTitleLabel.font = UIFont.SubTitle
        channelTitleLabel.font = UIFont.Title
        friendRequestLabel.font = UIFont.Content
        friendRequestLabel.textColor = UIColor.PGOrange
        explainLabel.font = UIFont.caption
        explainLabel.textColor = UIColor.customDarkGray
        videoTableView.isSkeletonable = true
        videoTableView.skeletonCornerRadius = 5
        let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
        videoTableView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray4, secondaryColor: .systemGray5), animation: animation, transition: .crossDissolve(0.5))
        profileImageView.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray4, secondaryColor: .systemGray5), animation: animation, transition: .crossDissolve(0.5))
        channelTitleLabel.showAnimatedGradientSkeleton(usingGradient: .init(baseColor: .systemGray4, secondaryColor: .systemGray5), animation: animation, transition: .crossDissolve(0.5))
    }
    
    func bindViewModel() {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        self.viewModel.$currentChannel.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] channel in
                guard let self = self, let info = channel else { return }
                self.profileImageView.downloadImageFrom(link: info.profileImage, contentMode: .scaleAspectFill)
                self.channelTitleLabel.text = info.nickName
                self.channelNameTitleLabel.text = info.nickName
                self.explainLabel.text = "친구 \(info.friendCnt)명 • 동영상 \(info.uploadCnt)개"
                self.viewModel.loadVideo(vc: self, coordinator: self.navVC?.coordinator)
                self.friendRequestButton.isEnabled = !(info.uuid == uuid)
            }.store(in: &cancellable)
        self.viewModel.$videoList.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] list in
                guard let self = self, list != nil else { return }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.videoTableView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
                    self.profileImageView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
                    self.channelTitleLabel.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.25))
                    self.friendRequestButton.isHidden = false
                    self.friendRequestLabel.isHidden = (self.viewModel.currentChannel?.uuid == uuid)
                    self.explainLabel.isHidden = false
                }
                self.videoTableView.reloadData()
            }.store(in: &cancellable)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey] {
                let newsize  = newvalue as! CGSize
                videoTableViewHeight.constant = newsize.height
            }
        }
    }
    
    // MARK: - Gesture Action
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func friendRequestButtonDidTap(_ sender: Any) {
        guard let channelInfo = self.viewModel.currentChannel, let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        friendRequestButton.isEnabled = false
        MainServiceAPI.shared.sendFriendRequest(uuid: uuid, target: channelInfo.uuid) { result in
            DispatchQueue.main.async {
                self.friendRequestButton.isEnabled = true
                guard let _ = NetworkResultManager.shared.analyze(result: result, vc: self, coordinator: self.navVC?.coordinator) else { return }
                self.friendRequestLabel.text = "요청 완료"
            }
        }
    }
}

extension ChannelViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.videoList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as? VideoListCell else { return UITableViewCell() }
        guard let videoList = self.viewModel.videoList else { return cell }
        cell.setupUI(indexPath.row)
        cell.setupVideo(info: videoList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let videoList = self.viewModel.videoList else { return }
        self.navVC?.coordinator?.showPlayer(info: videoList[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (videoTableView.contentSize.height - scrollView.frame.size.height) && !self.viewModel.isFinished {
            guard !self.viewModel.isLoading else {
                return
            }
            self.videoTableView.tableFooterView = createSpinnerFooter()
            self.viewModel.loadVideo(vc: self, coordinator: self.navVC?.coordinator)
        } else {
            // 더이상 로드할 데이터가 없을 경우, spinner 멈춤
            self.spinner.stopAnimating()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChannelViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "VideoListCell"
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
