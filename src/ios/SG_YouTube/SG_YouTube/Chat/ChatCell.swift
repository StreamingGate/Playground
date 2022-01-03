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
    
    func setUI() {
        profileImageView.backgroundColor = UIColor.placeHolder
        profileImageView.layer.cornerRadius = 33 / 2
        timeLabel.font = UIFont.bottomTab
        nicknameLabel.font = UIFont.highlightCaption
        nicknameLabel.textColor = UIColor.placeHolder
        contentLabel.font = UIFont.caption
    }
}
