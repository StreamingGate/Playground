//
//  FriendRequestViewController.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/02.
//

import Foundation
import UIKit
import Combine

class FriendRequestViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var navVC: HomeNavigationController?
    let viewModel = NoticeViewModel()
    private var cancellable: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? HomeNavigationController else { return }
        self.navVC = nav
        bindViewModel()
        setupUI()
    }
    
    func bindViewModel() {
        self.viewModel.$friendRequestList.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] list in
                guard let self = self else { return }
                self.tableView.reloadData()
            }.store(in: &cancellable)
    }
    
    func setupUI() {
        titleLabel.font = UIFont.SubTitle
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        navVC?.coordinator?.pop()
    }
}

extension FriendRequestViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.friendRequestList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestCell", for: indexPath) as? FriendRequestCell else {
            return UITableViewCell()
        }
        cell.updateUI(info: self.viewModel.friendRequestList[indexPath.row])
        cell.buttonHandler = { action in
            self.viewModel.answerFriendRequest(vc: self, action: action, friendUuid: self.viewModel.friendRequestList[indexPath.row].uuid, coordinator: self.navVC?.coordinator)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
