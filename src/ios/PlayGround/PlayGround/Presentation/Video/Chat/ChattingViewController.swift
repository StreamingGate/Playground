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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var viewerLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    let viewModel = ChatViewModel()
    private var cancellable: Set<AnyCancellable> = []
    @Published var isBottomFocused = true
    @IBOutlet weak var bottomScrollImageView: UIImageView!
    @IBOutlet weak var bottomScrollButton: UIButton!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 추후에 실제 roomId로 변경
        viewModel.roomId = "ae0a8eb9-ff2c-4256-8be7-f8a9e84a3afa"
        viewModel.connectToSocket()
        bindViewModelData()
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
    }
    
    func bindViewModelData() {
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
    }
    
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
        viewModel.sendMessage(message: message, nickname: nickname, type: chatType, role: senderRole)
    }
}
