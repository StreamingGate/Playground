//
//  FriendRequestCell.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/04.
//

import Foundation
import UIKit

class FriendRequestCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var rejectButton: UIButton!
    var buttonHandler: ((Int)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        nicknameLabel.font = UIFont.Content
        acceptButton.titleLabel?.font = UIFont.Content
        rejectButton.titleLabel?.font = UIFont.Content
        acceptButton.layer.cornerRadius = 3
        rejectButton.layer.cornerRadius = 3
        profileImageView.layer.cornerRadius = 20
    }
    
    func updateUI(info: Friend) {
        profileImageView.downloadImageFrom(link: info.profileImage, contentMode: .scaleAspectFill)
        nicknameLabel.text = info.nickname
    }
    
    @IBAction func acceptButtonDidTap(_ sender: Any) {
        buttonHandler?(1)
    }
    
    @IBAction func rejectButtonDidTap(_ sender: Any) {
        buttonHandler?(0)
    }
    
}
