//
//  PlayExplainViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class PlayExplainViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var explainTitleLabel: UILabel!
    @IBOutlet weak var videoTitleLabel: UILabel!
    @IBOutlet weak var viewerLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var explainContentLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var reportButton: UIButton!
    let viewModel = PlayViewModel()
    
    // MARK: - View LifeCycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backView.roundCorners([.topLeft , .topRight], radius: 20)
        scrollView.roundCorners([.topLeft , .topRight], radius: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        prepareAnimation()
        showAnimation()
    }
    
    // MARK: - UI Setting
    func setupUI() {
        explainTitleLabel.font = UIFont.caption
        explainTitleLabel.textColor = UIColor.customDarkGray
        videoTitleLabel.font = UIFont.Component
        viewerLabel.font = UIFont.caption
        viewerLabel.textColor = UIColor.customDarkGray
        categoryLabel.font = UIFont.highlightCaption
        channelLabel.font = UIFont.Content
        explainContentLabel.font = UIFont.caption
        explainContentLabel.textColor = UIColor.customDarkGray
        guard let info = viewModel.currentInfo else { return }
        videoTitleLabel.text = info.title
        categoryLabel.text = "#\(viewModel.categoryDic[info.category ?? ""] ?? "기타")"
        channelLabel.text = (info.uploaderNickname == nil) ? info.hostNickname : info.uploaderNickname
    }
    
    // MARK: - Animation
    func prepareAnimation(){
        self.view.transform = CGAffineTransform.init(translationX: 0, y: 200)
        self.view.alpha = 0
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        (self.parent as? PlayViewController)?.explainContainerView.alpha = 0
    }
    
    func showAnimation(){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: .showHideTransitionViews, animations: {
            self.view.transform = CGAffineTransform.identity
            self.view.alpha = 1
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            (self.parent as? PlayViewController)?.explainContainerView.alpha = 1
        }, completion: nil)
    }
    
    func disappearAnimation(){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: .showHideTransitionViews, animations: {
            self.view.transform = CGAffineTransform.init(translationX: 0, y: 200)
            self.view.alpha = 0
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            (self.parent as? PlayViewController)?.explainContainerView.alpha = 0
        }, completion: {_ in
            self.view.removeFromSuperview()
        })
    }
    
    // MARK: - Button Action
    @IBAction func likeButtonDidTap(_ sender: Any) {
        guard let info = viewModel.currentInfo, let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        likeButton.isEnabled = false
        if let liked = self.viewModel.isLiked, liked == true {
            MainServiceAPI.shared.cancelButtons(videoId: info.id, type: (info.hostNickname == nil ? 0 : 1), action: Action.Like, uuid: uuid) { result in
                DispatchQueue.main.async {
                    self.likeButton.isEnabled = true
                    if result["result"] as? String == "success" {
                        self.viewModel.likeCount = (self.viewModel.likeCount == 0 ? 0 : self.viewModel.likeCount - 1)
                        self.viewModel.isLiked = false
                    }
                }
            }
        } else {
            MainServiceAPI.shared.tapButtons(videoId: info.id, type: (info.hostNickname == nil ? 0 : 1), action: Action.Like, uuid: uuid) { result in
                print("result: \(result)")
                DispatchQueue.main.async {
                    self.likeButton.isEnabled = true
                    if result["result"] as? String == "success" {
                        self.viewModel.likeCount += 1
                        self.viewModel.isLiked = true
                    }
                }
            }
        }
    }
    
    @IBAction func dislikeButtonDidTap(_ sender: Any) {
        guard let info = viewModel.currentInfo, let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        dislikeButton.isEnabled = false
        if let disliked = self.viewModel.isDisliked, disliked == true {
            MainServiceAPI.shared.cancelButtons(videoId: info.id, type: (info.hostNickname == nil ? 0 : 1), action: Action.Dislike, uuid: uuid) { result in
                DispatchQueue.main.async {
                    self.dislikeButton.isEnabled = true
                    if result["result"] as? String == "success" {
                        self.viewModel.isDisliked = false
                    }
                }
            }
        } else {
            MainServiceAPI.shared.tapButtons(videoId: info.id, type: (info.hostNickname == nil ? 0 : 1), action: Action.Dislike, uuid: uuid) { result in
                print("result: \(result)")
                DispatchQueue.main.async {
                    self.dislikeButton.isEnabled = true
                    if result["result"] as? String == "success" {
                        self.viewModel.isDisliked = true
                    }
                }
            }
        }
    }
    
    @IBAction func shareButtonDidTap(_ sender: Any) {
        guard let id = self.viewModel.currentInfo?.id, let url = URL(string: "https://streaminggate.shop/video-play/\(id)") else { return }
        let shareSheetVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        present(shareSheetVC, animated: true, completion: nil)
    }
    
    
    @IBAction func reportButtonDidTap(_ sender: Any) {
        guard let info = viewModel.currentInfo, let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        reportButton.isEnabled = false
        MainServiceAPI.shared.tapButtons(videoId: info.id, type: (info.hostNickname == nil ? 0 : 1), action: Action.Report, uuid: uuid) { result in
            print("result: \(result)")
            DispatchQueue.main.async {
                self.reportButton.isEnabled = true
                if result["result"] as? String == "success" {
                    self.simpleAlert(message: "신고되었습니다")
                }
            }
        }
    }
    
    // MARK: - Tap Action
    // move to certain channel
    @IBAction func channelDidTap(_ sender: Any) {
        guard let parent = self.parent as? PlayViewController else { return }
        parent.setPlayViewMinimizing()
        parent.coordinator?.showChannel()
    }
    
    // close explain view
    @IBAction func closeButtonDidTap(_ sender: Any) {
        disappearAnimation()
    }
}
