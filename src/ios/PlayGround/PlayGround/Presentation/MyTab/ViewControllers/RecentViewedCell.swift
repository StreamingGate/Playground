//
//  RecentViewedCell.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/03.
//

import Foundation
import UIKit

class RecentViewedCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var lastPositionView: UIView!
    @IBOutlet weak var lastPositionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var channelNicknameLabel: UILabel!
    
    func setupUI() {
        thumbnailImageView.backgroundColor = UIColor.placeHolder
        titleLabel.font = UIFont.caption
        channelNicknameLabel.font = UIFont.caption
        channelNicknameLabel.textColor = UIColor.customDarkGray
    }
}
