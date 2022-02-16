//
//  ChatCell.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/29.
//

import Foundation
import UIKit

class ChatCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var streamerBorderView: UIView!
    
    func setupUI(info: ChatData) {
        if info.senderRole == "STREAMER" {
            streamerBorderView.layer.cornerRadius = 15
            streamerBorderView.layer.borderWidth = 2
            streamerBorderView.layer.borderColor = UIColor.PGOrange.cgColor
        } else {
            streamerBorderView.layer.borderWidth = 0
        }
        profileImageView.image = nil
        profileImageView.backgroundColor = UIColor.placeHolder
        profileImageView.layer.cornerRadius = 15
        profileImageView.downloadImageFrom(link: info.profileImage, contentMode: .scaleAspectFill)
        timeLabel.font = UIFont.bottomTab
        nicknameLabel.font = UIFont.highlightCaption
        nicknameLabel.textColor = UIColor.placeHolder
        contentLabel.font = UIFont.Content
        contentLabel.text = info.message
        nicknameLabel.text = info.nickname
        timeLabel.text = info.timeStamp.getDateString_chat()
    }
}
