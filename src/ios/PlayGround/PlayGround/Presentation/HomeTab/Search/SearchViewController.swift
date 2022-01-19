//
//  SearchViewController.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/14.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    var navVC: HomeNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let nav = self.navigationController as? HomeNavigationController else { return }
        self.navVC = nav
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchTextField.becomeFirstResponder()
    }
    
    func setupUI() {
        searchTextField.font = UIFont.Content
    }
    
    @IBAction func backButtonDidTap(_ sender: Any) {
        navVC?.coordinator?.pop()
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoListCell", for: indexPath) as? VideoListCell else { return UITableViewCell() }
        cell.setupUI(indexPath.row, 0)
        cell.channelTapHandler = {
            self.navVC?.coordinator?.showChannel()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navVC?.coordinator?.showPlayer()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
