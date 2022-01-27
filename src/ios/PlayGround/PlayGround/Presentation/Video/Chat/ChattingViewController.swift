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
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.connectToSocket()
        bingViewModelData()
        setupUI()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}



