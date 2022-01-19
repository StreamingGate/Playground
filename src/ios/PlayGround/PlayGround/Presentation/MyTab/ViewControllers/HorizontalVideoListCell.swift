//
//  HorizontalVideoListCell.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2022/01/10.
//

import Foundation
import UIKit

class HorizontalVideoListCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explainLabel1: UILabel!
    @IBOutlet weak var explainLabel2: UILabel!
    @IBOutlet weak var lastPositionWidth: NSLayoutConstraint!
    
    func setupUI() {
        thumbnailImageView.backgroundColor = UIColor.placeHolder
        titleLabel.font = UIFont.caption
        explainLabel1.font = UIFont.caption
        explainLabel1.textColor = UIColor.customDarkGray
        explainLabel2.font = UIFont.caption
        explainLabel2.textColor = UIColor.customDarkGray
    }
}
