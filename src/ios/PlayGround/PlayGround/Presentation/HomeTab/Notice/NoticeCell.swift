//
//  NoticeCell.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/04.
//

import Foundation
import UIKit

class NoticeCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var noticeLabel: UILabel!
    
    func updateUI(info: Notice) {
        profileImageView.layer.cornerRadius = 20
        profileImageView.backgroundColor = UIColor.placeHolder
        noticeLabel.font = UIFont.Content
        noticeLabel.text = info.content
    }
}
