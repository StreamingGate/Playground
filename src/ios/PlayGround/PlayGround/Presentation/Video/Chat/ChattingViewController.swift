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
    var isBottomFocused = true
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // 추후에 실제 roomId로 변경
        viewModel.roomId = "e48b352a-111f-4b49-8a86-4ba9e6be3495"
        viewModel.connectToSocket()
        bingViewModelData()
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
    }
    
    func bingViewModelData() {
        viewModel.$chatList.receive(on: RunLoop.main)
            .sink { [weak self] list in
                guard let self = self else { return }
                self.tableView.reloadData()
                if self.isBottomFocused {
                    self.tableView.scrollToBottom()
                }
            }.store(in: &cancellable)
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
            isBottomFocused = false
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
