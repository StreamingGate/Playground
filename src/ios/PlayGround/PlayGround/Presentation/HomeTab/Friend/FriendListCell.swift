//
//  FriendListCell.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/04.
//

import Foundation
import UIKit

class FriendListCell: UITableViewCell {
    // MARK: - Properties
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var onlineMarkView: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    var deleteHandler: (()->Void)?
    
    // MARK: - UI Setting
    /**
     사이드바에서 친구 리스트 조회
     */
    func setupUI_list(info: Friend) {
        friendNameLabel.text = info.nickname
        profileImageView.downloadImageFrom(link: info.profileImage, contentMode: .scaleAspectFill)
        deleteButton.isHidden = true
        friendNameLabel.font = UIFont.Content
        profileImageView.layer.cornerRadius = 15
        profileImageView.backgroundColor = UIColor.placeHolder
        onlineMarkView.layer.cornerRadius = 4
    }
    
    /**
     마이페이지에서 친구 관리 조회
     */
    func setupUI_manage(info: Friend) {
        friendNameLabel.text = info.nickname
        profileImageView.downloadImageFrom(link: info.profileImage, contentMode: .scaleAspectFill)
        deleteButton.isHidden = false
        friendNameLabel.font = UIFont.Content
        profileImageView.layer.cornerRadius = 15
        profileImageView.backgroundColor = UIColor.placeHolder
        onlineMarkView.layer.cornerRadius = 4
    }
    
    @IBAction func deleteButtonDidTap(_ sender: Any) {
        deleteHandler?()
    }
}
