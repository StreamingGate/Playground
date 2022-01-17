//
//  FriendListViewController.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/14.
//

import Foundation
import UIKit

class FriendListViewController: UIViewController {
    @IBOutlet weak var friendListView: UIView!
    @IBOutlet weak var listViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var listViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var listTItleLabel: UILabel!
    @IBOutlet weak var friendTableView: UITableView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        listViewTopMargin.constant = -self.view.safeAreaInsets.top
        listViewBottomMargin.constant = -self.view.safeAreaInsets.bottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        listTItleLabel.font = UIFont.highlightCaption
        listTItleLabel.textColor = UIColor.placeHolder
    }
    
    @IBAction func backTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate {
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
        guard let popUp = UIStoryboard(name: "Friend", bundle: nil).instantiateViewController(withIdentifier: "FriendPopUpViewController") as? FriendPopUpViewController else { return }
        self.addChild(popUp)
        self.view.addSubview((popUp.view)!)
        popUp.view.frame = self.view.bounds
        popUp.didMove(toParent: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


class FriendListCell: UITableViewCell {
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var onlineMarkView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    func setupUI() {
        friendNameLabel.font = UIFont.Content
        profileImageView.layer.cornerRadius = 15
        profileImageView.backgroundColor = UIColor.placeHolder
        onlineMarkView.layer.cornerRadius = 4
    }
    
}

extension FriendListViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.friendListView) == true {
            return false
        }
        return true
    }
}
