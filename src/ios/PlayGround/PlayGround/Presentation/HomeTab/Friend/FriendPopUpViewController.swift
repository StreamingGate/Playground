//
//  FriendPopUpViewController.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/14.
//

import Foundation
import UIKit

class FriendPopUpViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var onlineMarkView: UIView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var watchButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    
    let viewModel = FriendViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Setting
    func setupUI() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        popUpView.layer.cornerRadius = 5
        profileImageView.layer.cornerRadius = 45 / 2
        profileImageView.backgroundColor = UIColor.placeHolder
        onlineMarkView.layer.cornerRadius = 6
        nickNameLabel.font = UIFont.Component
        roomNameLabel.font = UIFont.Content
        roomNameLabel.textColor = UIColor.customDarkGray
        watchButton.layer.cornerRadius = 15
        cancelButton.layer.cornerRadius = 15
        guard let info = viewModel.currentFriend else { return }
        onlineMarkView.isHidden = !info.status
        profileImageView.downloadImageFrom(link: info.profileImage, contentMode: .scaleAspectFill)
        nickNameLabel.text = info.nickname
        if let roomName = info.title {
            roomNameLabel.text = roomName
        } else {
            roomNameLabel.text = "영상 미시청"
        }
    }
    
    @IBAction func watchButtonDidTap(_ sender: Any) {
        guard let info = self.viewModel.currentFriend, let idInfo = info.id, let titleInfo = info.title, let type = info.type else { return }
        guard let parent = self.parent as? FriendListViewController else { return }
        let test = GeneralVideo(id: idInfo, title: titleInfo, hostNickname: type == 0 ? nil: "live", hostUuid: "", uploaderNickname: type == 0 ? "video": nil, uploaderUuid: "", fileLink: "", thumbnail: "", hits: 0, category: "", createdAt: "", streamingId: "", chatRoomId: "", uuid: "", likedAt: "", lastViewedAt: "")
        parent.transitionDelegate?.showPlayer(info: test)
        self.parent?.dismiss(animated: true, completion: {
        })
    }
    
    // MARK: - Button Action
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}
