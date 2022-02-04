//
//  AccountInfoViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import Combine

class AccountInfoViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var navVC: MyPageNavigationController?
    
    private var cancellable: Set<AnyCancellable> = []
    let viewModel = AccountInfoViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? MyPageNavigationController else { return }
        self.navVC = nav
        bindViewModel()
        setupUI()
        self.viewModel.loadFriend()
    }
    
    func bindViewModel() {
        self.viewModel.$friendList.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            }.store(in: &cancellable)
    }
    
    func setupUI() {
        logOutLabel.font = UIFont.Component
        nicknameLabel.font = UIFont.Content
        editButton.titleLabel?.font = UIFont.caption
        profileImageView.layer.cornerRadius = 35 / 2
        profileImageView.backgroundColor = UIColor.placeHolder
    }
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.navVC?.coordinator?.dismiss()
    }
    
    @IBAction func logOutButtonDidTap(_ sender: Any) {
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.accessToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.uuid.rawValue)
        self.navVC?.coordinator?.dismissToRoot()
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        self.navVC?.coordinator?.pop()
    }
    
    @IBAction func editButtonDidTap(_ sender: Any) {
        self.navVC?.coordinator?.showAccountEdit()
    }
}

extension AccountInfoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as? FriendListCell else {
            return UITableViewCell()
        }
        cell.setupUI_manage(info: self.viewModel.friendList[indexPath.row])
        cell.deleteHandler = {
            self.viewModel.deleteFriend(friendUuid: self.viewModel.friendList[indexPath.row].uuid, vc: self)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navVC?.coordinator?.showChannel()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
