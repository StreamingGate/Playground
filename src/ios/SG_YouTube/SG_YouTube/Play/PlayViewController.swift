//
//  PlayViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/29.
//

import Foundation
import UIKit

class PlayViewController: UIViewController {
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var channelProfileImageView: UIImageView!
    @IBOutlet weak var channelNicknameLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var chatSendButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatPlaceHolderLabel: UILabel!
    @IBOutlet weak var chatProfileImageView: UIImageView!
    @IBOutlet weak var chatSeparatorView: UIView!
    @IBOutlet weak var chatViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var explainContainerView: UIView!
    @IBOutlet weak var chatContainerViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var chatContainerView: UIView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        setUI()
    }
    
    // MARK: - UI Setting
    func setUI() {
        titleLabel.font = UIFont.Component
        viewLabel.font = UIFont.caption
        viewLabel.textColor = UIColor.customDarkGray
        categoryLabel.font = UIFont.highlightCaption
        channelNicknameLabel.font = UIFont.Content
        channelProfileImageView.backgroundColor = UIColor.placeHolder
        channelProfileImageView.layer.cornerRadius = 33 / 2
        chatSendButton.layer.cornerRadius = 15
        chatPlaceHolderLabel.font = UIFont.Content
        chatProfileImageView.backgroundColor = UIColor.placeHolder
        chatTextView.font = UIFont.Content
        chatProfileImageView.layer.cornerRadius = 25 / 2
        connectChatView()
    }
    
    func connectChatView() {
        guard let chattingVC = UIStoryboard(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChattingViewController") as? ChattingViewController else { return }
        self.addChild(chattingVC)
        self.chatContainerView.addSubview((chattingVC.view)!)
        chattingVC.view.frame = self.chatContainerView.bounds
        chattingVC.didMove(toParent: self)
    }
    
    // MARK: - Button Action
    @IBAction func explainStretchButtonDidTap(_ sender: Any) {
        guard let explainVC = UIStoryboard(name: "Play", bundle: nil).instantiateViewController(withIdentifier: "PlayExplainViewController") as? PlayExplainViewController else { return }
        self.addChild(explainVC)
        self.explainContainerView.addSubview((explainVC.view)!)
        explainVC.view.frame = self.explainContainerView.bounds
        explainVC.didMove(toParent: self)
    }
    
    @IBAction func tempBackButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backTapped(_ sender: Any) {
        chatTextView.resignFirstResponder()
    }
}

extension PlayViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        chatPlaceHolderLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        chatPlaceHolderLabel.isHidden = !(textView.text.count == 0)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        chatPlaceHolderLabel.isHidden = !(textView.text.count == 0)
    }
}

extension PlayViewController {
    // MARK: - Keyboard up/down adjustment
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            chatViewBottom.constant = adjustmentHeight
            self.view.layoutIfNeeded()
        } else {
            chatViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
