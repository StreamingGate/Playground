//
//  NoticeListViewController.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/14.
//

import Foundation
import UIKit

class NoticeListViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    var navVC: HomeNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? HomeNavigationController else { return }
        self.navVC = nav
        setupUI()
    }
    
    func setupUI() {
        titleLabel.font = UIFont.SubTitle
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        navVC?.coordinator?.pop()
    }
}

extension NoticeListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
