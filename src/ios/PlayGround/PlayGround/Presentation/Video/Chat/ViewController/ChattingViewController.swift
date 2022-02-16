//
//  ChattingViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/29.
//

import Foundation
import UIKit
import Combine

class ChattingViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let viewModel = ChatViewModel(senderRole: "VIEWER")
    private var cancellable: Set<AnyCancellable> = []
    @Published var isBottomFocused = true
    @IBOutlet weak var bottomScrollImageView: UIImageView!
    @IBOutlet weak var bottomScrollButton: UIButton!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var pinnedView: UIView!
    @IBOutlet weak var pinnedImageView: UIImageView!
    @IBOutlet weak var pinnedTimeLabel: UILabel!
    @IBOutlet weak var pinnedBorderView: UIView!
    var roomId = ""
    var isLive = false
    @IBOutlet weak var pinnedNickname: UILabel!
    @IBOutlet weak var pinnedContent: UILabel!
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.roomId = self.roomId
        viewModel.connectToSocket()
        bindData()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.disconnectToSocket()
    }
    
    // MARK: - UI Setting
    func setupUI() {
        titleLabel.font = UIFont.Component
        viewerLabel.font = UIFont.caption
        viewerLabel.textColor = UIColor.customDarkGray
        tableView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
        pinnedImageView.image = nil
        pinnedImageView.backgroundColor = UIColor.placeHolder
        pinnedImageView.layer.cornerRadius = 15
        pinnedTimeLabel.font = UIFont.highlightCaption
        pinnedTimeLabel.textColor = UIColor.PGBlue
        pinnedNickname.font = UIFont.highlightCaption
        pinnedNickname.textColor = UIColor.placeHolder
        pinnedContent.font = UIFont.Content
        pinnedView.layer.borderColor = UIColor.separator.cgColor
        pinnedView.layer.borderWidth = 1
        pinnedView.layer.cornerRadius = 5
        pinnedBorderView.layer.cornerRadius = 15
        pinnedBorderView.layer.borderColor = UIColor.PGOrange.cgColor
        pinnedBorderView.layer.borderWidth = 2
    }
    
    // MARK: - Data Binding
    func bindData() {
        viewModel.$chatList.receive(on: RunLoop.main)
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
                guard let self = self, let parent = self.parent as? PlayViewController else { return }
                parent.viewModel.userCount = countNum
                self.viewerLabel.text = "\(countNum)명"
            }.store(in: &cancellable)
        viewModel.$pinned.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] pinnedChat in
                guard let self = self else { return }
                if let info = pinnedChat {
                    print("pinned")
                    self.pinnedView.isHidden = false
                    self.pinnedImageView.downloadImageFrom(link: info.profileImage, contentMode: .scaleAspectFill)
                    self.pinnedContent.text = info.message
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
    @IBAction func bottomScrollButtonDidTap(_ sender: Any) {
        self.tableView.scrollToBottom()
        isBottomFocused = true
    }
}

// MARK: - Chatting List (TableView)
extension ChattingViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell else { return UITableViewCell()}
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

extension ChattingViewController: ChatSendDelegate {
    func sendChatMessage(nickname: String, message: String, senderRole: String, chatType: String) {
        viewModel.sendMessage(message: message, nickname: nickname, type: chatType)
    }
}
