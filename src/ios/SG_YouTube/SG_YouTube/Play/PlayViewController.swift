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
    @IBOutlet weak var playControllView: UIView!
    var playControllTimer = Timer()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var channelProfileImageView: UIImageView!
    @IBOutlet weak var channelNicknameLabel: UILabel!
    @IBOutlet weak var channelView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var chatSendButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatPlaceHolderLabel: UILabel!
    @IBOutlet weak var chatProfileImageView: UIImageView!
    @IBOutlet weak var chatSeparatorView: UIView!
    @IBOutlet weak var chatViewBottom: NSLayoutConstraint!
    @IBOutlet weak var playViewTop: NSLayoutConstraint!
    @IBOutlet weak var playViewCenterX: NSLayoutConstraint!
    
    @IBOutlet weak var explainContainerView: UIView!
    @IBOutlet weak var chatContainerViewTop: NSLayoutConstraint!
    @IBOutlet weak var chatContainerView: UIView!
    @IBOutlet weak var chatContainerViewLeading: NSLayoutConstraint!
    @IBOutlet weak var chatContainerViewCenterX: NSLayoutConstraint!
    
    var portraitLayout: [NSLayoutConstraint] = []
    var landscapeLayout: [NSLayoutConstraint] = []
    
    var safeTop: CGFloat = 0
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        portraitLayout = [chatContainerViewLeading, chatContainerViewCenterX, chatContainerViewTop, playViewTop, playViewCenterX]
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
    
    @IBAction func enlargeButtonDidTap(_ sender: Any) {
        if UIDevice.current.value(forKey: "orientation") as? Int == UIInterfaceOrientation.landscapeRight.rawValue {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            titleLabel.isHidden = false
            viewLabel.isHidden = false
            categoryLabel.isHidden = false
            stackView.isHidden = false
            self.view.backgroundColor = UIColor.white
            NSLayoutConstraint.deactivate(landscapeLayout)
            NSLayoutConstraint.activate(portraitLayout)
        } else {
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
            chatContainerView.translatesAutoresizingMaskIntoConstraints = false
            playView.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.isHidden = true
            viewLabel.isHidden = true
            categoryLabel.isHidden = true
            stackView.isHidden = true
            NSLayoutConstraint.deactivate(portraitLayout)
            landscapeLayout = [chatContainerView.topAnchor.constraint(equalTo: self.view.topAnchor),
               playView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
               playView.trailingAnchor.constraint(equalTo: self.chatContainerView.leadingAnchor),
               chatContainerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width > UIScreen.main.bounds.height ? UIScreen.main.bounds.height : UIScreen.main.bounds.width)]
            self.view.backgroundColor = UIColor.black
            NSLayoutConstraint.activate(landscapeLayout)
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        chatTextView.resignFirstResponder()
    }
    
    @IBAction func playViewTapped(_ sender: Any) {
        chatTextView.resignFirstResponder()
        self.playControllTimer.invalidate()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.playControllView.alpha = 1
        } completion: { _ in
            self.playControllTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { timer in
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
                    self.playControllView.alpha = 0
                }
            })
        }
    }
    
    @IBAction func playControllerViewTapped(_ sender: Any) {
        self.playControllTimer.invalidate()
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.playControllView.alpha = 0
        }
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
