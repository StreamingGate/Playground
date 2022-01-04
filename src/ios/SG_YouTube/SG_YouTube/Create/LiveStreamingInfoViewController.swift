//
//  LiveStreamingInfoViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit

class LiveStreamingInfoViewController: UIViewController {
    @IBOutlet weak var currentAccountLabel: UILabel!
    @IBOutlet weak var accountNicknameLabel: UILabel!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var titleTextView: UITextView!
    @IBOutlet weak var explainTextView: UITextView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    @IBOutlet weak var categoryContentLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var thumbnailImageTitleLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var thumbnailButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingCancelButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        currentAccountLabel.font = UIFont.bottomTab
        currentAccountLabel.textColor = UIColor.background
        accountNicknameLabel.font = UIFont.Component
        accountNicknameLabel.textColor = UIColor.background
        detailTitleLabel.font = UIFont.Content
        detailTitleLabel.textColor = UIColor.background
        
        titleTextView.textColor = UIColor.background
        titleTextView.font = UIFont.caption
        titleTextView.layer.borderColor = UIColor.placeHolder.cgColor
        titleTextView.layer.borderWidth = 1
        titleTextView.layer.cornerRadius = 10
        
        explainTextView.textColor = UIColor.background
        explainTextView.font = UIFont.caption
        explainTextView.layer.borderColor = UIColor.placeHolder.cgColor
        explainTextView.layer.borderWidth = 1
        explainTextView.layer.cornerRadius = 10
        
        categoryButton.layer.borderColor = UIColor.placeHolder.cgColor
        categoryButton.layer.borderWidth = 1
        categoryButton.layer.cornerRadius = 10
        
        thumbnailButton.layer.borderColor = UIColor.placeHolder.cgColor
        thumbnailButton.layer.borderWidth = 1
        thumbnailButton.layer.cornerRadius = 10
        
        categoryTitleLabel.font = UIFont.Content
        categoryTitleLabel.textColor = UIColor.background
        categoryContentLabel.font = UIFont.caption
        categoryContentLabel.textColor = UIColor.background
        
        thumbnailImageTitleLabel.font = UIFont.Content
        thumbnailImageTitleLabel.textColor = UIColor.background
        
        startButton.backgroundColor = UIColor.youtubeRed
        startButton.titleLabel?.font = UIFont.SubTitle
        startButton.layer.cornerRadius = 20
        
        profileImageView.backgroundColor = UIColor.separator
        profileImageView.layer.cornerRadius = 33 / 2
        
        loadingLabel.font = UIFont.Tab
        loadingLabel.textColor = UIColor.white
        
        loadingCancelButton.backgroundColor = UIColor.white
        loadingCancelButton.tintColor = UIColor.black
        loadingCancelButton.titleLabel?.font = UIFont.SubTitle
        loadingCancelButton.layer.cornerRadius = 20
    }
    
    @IBAction func startButtonDidTap(_ sender: Any) {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut) {
            self.loadingView.alpha = 1
        }
    }
    
    @IBAction func loadingCancleButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
