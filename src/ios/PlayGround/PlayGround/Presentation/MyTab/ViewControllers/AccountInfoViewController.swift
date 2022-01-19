//
//  AccountInfoViewController.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit

class AccountInfoViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var logOutLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    var navVC: MyPageNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? MyPageNavigationController else { return }
        self.navVC = nav
        setupUI()
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
        self.navVC?.coordinator?.showChannel()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
