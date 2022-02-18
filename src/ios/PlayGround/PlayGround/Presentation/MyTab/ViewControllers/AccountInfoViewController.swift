//
//  AccountInfoViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

class AccountInfoViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    var navVC: MyPageNavigationController?
    
    private var cancellable: Set<AnyCancellable> = []
    let viewModel = AccountInfoViewModel()
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? MyPageNavigationController else { return }
        self.navVC = nav
        bindData()
        setupUI()
        self.viewModel.loadFriend(vc: self, coordinator: self.navVC?.coordinator)
    }
    
    // MARK: - UI Setting
    func setupUI() {
        logOutLabel.font = UIFont.Component
        nicknameLabel.font = UIFont.Content
        editButton.titleLabel?.font = UIFont.caption
        profileImageView.layer.cornerRadius = 35 / 2
        profileImageView.backgroundColor = UIColor.placeHolder
        profileImageView.layer.borderColor = UIColor.placeHolder.cgColor
        profileImageView.layer.borderWidth = 1
    }
    
    // MARK: - Data Binding
    func bindData() {
        self.viewModel.$friendList.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.tableView.reloadData()
            }.store(in: &cancellable)
        UserManager.shared.$userInfo.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] user in
                guard let self = self, let userInfo = user else { return }
                self.profileImageView.downloadImageFrom(link: userInfo.profileImage, contentMode: .scaleAspectFill)
                self.nicknameLabel.text = userInfo.nickName
            }.store(in: &cancellable)
    }
    
    // MARK: - Button Action
    @IBAction func closeButtonDidTap(_ sender: Any) {
        self.navVC?.coordinator?.dismiss()
    }
    
    @IBAction func logOutButtonDidTap(_ sender: Any) {
        StatusManager.shared.disconnectToSocket()
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.accessToken.rawValue)
        KeychainWrapper.standard.removeObject(forKey: KeychainWrapper.Key.uuid.rawValue)
        UserManager.shared.userInfo = nil
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
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as? FriendListCell else {
            return UITableViewCell()
        }
        cell.setupUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navVC?.coordinator?.showChannel(uuid: self.viewModel.friendList[indexPath.row].uuid)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
