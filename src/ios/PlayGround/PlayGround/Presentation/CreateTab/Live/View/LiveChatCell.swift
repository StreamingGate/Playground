//
//  LiveChatCell.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/10.
//

import Foundation
import UIKit

class LiveChatCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var streamerBorderView: UIView!
    
    func setupUI(info : ChatData) {
        if info.senderRole == "STREAMER" {
            streamerBorderView.layer.cornerRadius = 20
            streamerBorderView.layer.borderWidth = 2
            streamerBorderView.layer.borderColor = UIColor.PGOrange.cgColor
        } else {
            streamerBorderView.layer.borderWidth = 0
        }
        profileImageView.backgroundColor = UIColor.placeHolder
        profileImageView.layer.cornerRadius = 20
        nicknameLabel.font = UIFont.Tab
        nicknameLabel.textColor = UIColor.white
        contentLabel.textColor = UIColor.white
        contentLabel.font = UIFont.Component
        contentLabel.text = info.message
        nicknameLabel.text = info.nickname
        profileImageView.downloadImageFrom(link: info.profileImage, contentMode: .scaleAspectFill)
    }
}
