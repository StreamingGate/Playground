//
//  PlayExplainViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit

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
    let viewModel = PlayViewModel()
    
    // MARK: - View Life Cycle
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
        categoryLabel.text = "#\(viewModel.categoryDic[info.category] ?? "기타")"
        channelLabel.text = (info.uploaderNickname == nil) ? info.hostNickname : info.uploaderNickname
//        channelProfileImageView.downloadImageFrom(link: info., contentMode: <#T##UIView.ContentMode#>)
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
