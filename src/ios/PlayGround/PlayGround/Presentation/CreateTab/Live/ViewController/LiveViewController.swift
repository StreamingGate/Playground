//
//  LiveViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/10.
//

import Foundation
import UIKit
import AVFoundation
import Photos
import Combine
import SafariServices
import SwiftKeychainWrapper

class LiveViewController: UIViewController {
    // MARK: - Properties
    let viewModel = ChatViewModel(senderRole: "STREAMER")
    private var cancellable: Set<AnyCancellable> = []
    @Published var isBottomFocused = true
    @Published var isPinned = false
    @IBOutlet weak var pinSendImageView: UIImageView!
    @IBOutlet weak var pinSendButton: UIButton!
    @IBOutlet weak var pinSendLabel: UILabel!
    @IBOutlet weak var pinnedContentLabel: UILabel!
    @IBOutlet weak var pinnedLabel: UILabel!
    @IBOutlet weak var pinnedNickname: UILabel!
    @IBOutlet weak var pinnedView: UIView!
    @IBOutlet weak var pinnedImageView: UIImageView!
    @IBOutlet weak var pinnedStreamerBorderView: UIView!
    @IBOutlet weak var topBlackViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var topBlackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var chatViewBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomScrollImageView: UIImageView!
    @IBOutlet weak var bottomScrollButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var liveSignRedView: UIView!
    @IBOutlet weak var liveSignLabel: UILabel!
    @IBOutlet weak var timeBlackView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var participantsNumLabel: UILabel!
    @IBOutlet weak var likeNumLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTextView: UITextView!
    @IBOutlet weak var chatProfileImageView: UIImageView!
    @IBOutlet weak var chatPlaceHolderLabel: UILabel!
    @IBOutlet weak var chatCountLabel: UILabel!
    @IBOutlet weak var liveEndView: UIView!
    @IBOutlet weak var infoStackView: UIStackView!
    var safeBottom: CGFloat = 0
    var coordinator: PlayerCoordinator?

    var currentTime = 0
    var timer = Timer()
    
    var navVC: CreateNavigationController?
    
    // MARK: - View LifeCycle
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        liveSignRedView.roundCorners([.topLeft , .bottomLeft], radius: 3)
        timeBlackView.roundCorners([.topRight , .bottomRight], radius: 3)
        safeBottom = self.parent?.view.safeAreaInsets.bottom ?? 0
        topBlackViewTopMargin.constant = -(self.parent?.view.safeAreaInsets.top ?? 0)
        topBlackViewHeight.constant = 50 + (self.parent?.view.safeAreaInsets.top ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        guard let nav = self.navigationController as? CreateNavigationController, let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        self.navVC = nav
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerAction), userInfo: nil, repeats: true)
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        guard let url = URL(string: "https://streaminggate.shop/m/studio/\(nav.roomUuid)/\(uuid)") else { return }
        SFSafariViewController.shared = SFSafariViewController(url: url, configuration: config)
        SFSafariViewController.shared.delegate = self
        SFSafariViewController.shared.view.frame = self.view.bounds
        self.view.addSubview(SFSafariViewController.shared.view)
        self.addChild(SFSafariViewController.shared)
        SFSafariViewController.shared.didMove(toParent: self)
        self.view.sendSubviewToBack(SFSafariViewController.shared.view)
        self.view.sendSubviewToBack(self.liveEndView)
        setupUI()
        viewModel.roomId = nav.roomUuid
        viewModel.connectToSocket()
        bindViewModelData()
    }
    
    func setupUIforClose() {
        pinnedView.isHidden = true
        infoStackView.isHidden = true
        tableView.isHidden = true
        sendButton.isEnabled = false
    }
    
    @objc func timerAction() {
        currentTime += 1
        let hours = currentTime / 3600
        let mins = currentTime / 60
        let secs = currentTime % 60
        if hours == 0 {
            timeLabel.text = "\(String(format: "%02d", mins)):\(String(format: "%02d", secs))"
        } else {
            timeLabel.text = "\(String(format: "%02d", hours)):\(String(format: "%02d", mins)):\(String(format: "%02d", secs))"
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.disconnectToSocket()
    }
    
    // MARK: - UI Setting
    func setupUI() {
        sendButton.setTitle("", for: .normal)
        liveSignLabel.font = UIFont.caption
        timeLabel.font = UIFont.caption
        participantsNumLabel.font = UIFont.caption
        likeNumLabel.font = UIFont.caption
        pinnedImageView.image = nil
        pinnedImageView.backgroundColor = UIColor.placeHolder
        pinnedImageView.layer.cornerRadius = 15
        pinnedLabel.font = UIFont.highlightCaption
        pinnedLabel.textColor = UIColor.PGBlue
        pinnedNickname.font = UIFont.highlightCaption
        pinnedNickname.textColor = UIColor.placeHolder
        pinnedContentLabel.font = UIFont.Content
        pinnedView.layer.borderColor = UIColor.separator.cgColor
        pinnedView.layer.borderWidth = 1
        pinnedView.layer.cornerRadius = 5
        pinnedStreamerBorderView.layer.cornerRadius = 15
        pinnedStreamerBorderView.layer.borderColor = UIColor.PGOrange.cgColor
        pinnedStreamerBorderView.layer.borderWidth = 2
        guard let profile = UserManager.shared.userInfo?.profileImage else { return }
        chatProfileImageView.downloadImageFrom(link: profile, contentMode: .scaleAspectFill)
        chatProfileImageView.layer.cornerRadius = 25 / 2
    }
    
    // MARK: - Data Binding
    func bindViewModelData() {
        viewModel.$chatList.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] list in
                guard let self = self else { return }
                self.tableView.reloadData()
                if self.isBottomFocused {
                    self.tableView.scrollToBottom()
                }
            }.store(in: &cancellable)
        $isBottomFocused.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] isFocused in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: .showHideTransitionViews, animations: {
                    if isFocused {
                        self.bottomScrollButton.alpha = 0
                        self.bottomScrollImageView.alpha = 0
                    } else {
                        self.bottomScrollButton.alpha = 1
                        self.bottomScrollImageView.alpha = 1
                    }
                }, completion: nil)
            }.store(in: &cancellable)
        viewModel.$userCount.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] countNum in
                guard let self = self else { return }
                self.participantsNumLabel.text = "\(countNum)"
            }.store(in: &cancellable)
        viewModel.$pinned.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] pinnedChat in
                guard let self = self else { return }
                if let info = pinnedChat {
                    print("pinned")
                    self.pinnedView.isHidden = false
                    self.pinnedImageView.downloadImageFrom(link: info.profileImage, contentMode: .scaleAspectFill)
                    self.pinnedContentLabel.text = info.message
                    self.pinnedNickname.text = info.nickname
                    self.pinnedView.layoutIfNeeded()
                    print("height: \(self.pinnedView.bounds.height)")
                    self.tableView.contentInset = UIEdgeInsets(top: self.pinnedView.bounds.height + 25, left: 0, bottom: 0, right: 0)
                } else {
                    print("normal")
                    self.pinnedView.isHidden = true
                    self.tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
                }
            }.store(in: &cancellable)
    }
    
    // MARK: - Button Action
    @IBAction func sendButtonDidTap(_ sender: Any) {
        chatTextView.resignFirstResponder()
        guard let message = chatTextView.text, message.isEmpty == false, let userInfo = UserManager.shared.userInfo, let nickname = userInfo.nickName else { return }
        chatTextView.text = ""
        chatPlaceHolderLabel.isHidden = false
        chatCountLabel.textColor = UIColor.placeHolder
        chatCountLabel.text = "0/200"
        viewModel.sendMessage(message: message, nickname: nickname, type: isPinned == true ? "PINNED" : "NORMAL")
    }
    
    @IBAction func pinnedButtonClicked(_ sender: Any) {
        isPinned = !isPinned
        if isPinned {
            pinSendLabel.textColor = UIColor.PGBlue
            pinSendImageView.tintColor = UIColor.PGBlue
            pinSendImageView.image = UIImage(systemName: "checkmark.square.fill")
        } else {
            pinSendLabel.textColor = UIColor.placeHolder
            pinSendImageView.tintColor = UIColor.placeHolder
            pinSendImageView.image = UIImage(systemName: "square")
        }
    }
    
    @IBAction func bottomScrollDidTap(_ sender: Any) {
        self.tableView.scrollToBottom()
        isBottomFocused = true
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension LiveViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LiveChatCell", for: indexPath) as? LiveChatCell else { return UITableViewCell()}
        cell.setupUI(info: viewModel.chatList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 스크롤이 하단이 아닐 경우 새 메세지가 왔을 때 하단으로 자동 스크롤되지 않도록
        if (viewModel.chatList.count - 1) == indexPath.row {
            if viewModel.isMaximum == true {
                viewModel.isMaximum = false
            } else {
                isBottomFocused = false
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 스크롤이 하단일 경우 새 메세지가 왔을 때 하단으로 자동 스크롤되도록
        if (viewModel.chatList.count - 1) == indexPath.row {
            isBottomFocused = true
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension LiveViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        chatPlaceHolderLabel.isHidden = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        chatPlaceHolderLabel.isHidden = !(textView.text.count == 0)
        if textView.text.count > 200 {
            textView.deleteBackward()
            chatCountLabel.textColor = UIColor.red
            return
        }
        chatCountLabel.textColor = UIColor.placeHolder
        chatCountLabel.text = "\(textView.text.count)/200"
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        chatPlaceHolderLabel.isHidden = !(textView.text.count == 0)
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            guard let message = chatTextView.text, message.isEmpty == false, let userInfo = UserManager.shared.userInfo, let nickname = userInfo.nickName else { return false }
            chatTextView.text = ""
            chatPlaceHolderLabel.isHidden = false
            chatCountLabel.textColor = UIColor.placeHolder
            chatCountLabel.text = "0/200"
            viewModel.sendMessage(message: message, nickname: nickname, type: "NORMAL")
            return false
        }
        return true
    }
}

// MARK: - Keyboard up/down adjustment
extension LiveViewController {
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - safeBottom
            chatViewBottom.constant = adjustmentHeight
            self.view.layoutIfNeeded()
        } else {
            chatViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
