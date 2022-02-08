//
//  FriendListViewController.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/14.
//

import Foundation
import UIKit
import Combine

class FriendListViewController: UIViewController {
    @IBOutlet weak var friendListView: UIView!
    @IBOutlet weak var listViewTopMargin: NSLayoutConstraint!
    @IBOutlet weak var listViewBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var listTItleLabel: UILabel!
    @IBOutlet weak var friendTableView: UITableView!
    private var cancellable: Set<AnyCancellable> = []
    let viewModel = FriendViewModel()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        listViewTopMargin.constant = -self.view.safeAreaInsets.top
        listViewBottomMargin.constant = -self.view.safeAreaInsets.bottom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupUI()
        self.viewModel.loadFriend(vc: self, coordinator: nil)
    }
    
    func disappearAnimation(){
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 2, initialSpringVelocity: 2, options: .showHideTransitionViews, animations: {
            self.friendListView.transform = CGAffineTransform.init(translationX: 100, y: 0)
            self.friendListView.alpha = 0
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }, completion: {_ in
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func bindViewModel() {
        self.viewModel.$friendList.receive(on: DispatchQueue.main, options: nil)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.friendTableView.reloadData()
            }.store(in: &cancellable)
    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        listTItleLabel.font = UIFont.highlightCaption
        listTItleLabel.textColor = UIColor.placeHolder
    }
    
    @IBAction func backTapped(_ sender: Any) {
        disappearAnimation()
    }
}

extension FriendListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.friendList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendListCell", for: indexPath) as? FriendListCell else {
            return UITableViewCell()
        }
        cell.setupUI_list(info: self.viewModel.friendList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let popUp = UIStoryboard(name: "Friend", bundle: nil).instantiateViewController(withIdentifier: "FriendPopUpViewController") as? FriendPopUpViewController else { return }
        popUp.viewModel.currentFriend = self.viewModel.friendList[indexPath.row]
        self.addChild(popUp)
        self.view.addSubview((popUp.view)!)
        popUp.view.frame = self.view.bounds
        popUp.didMove(toParent: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
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
