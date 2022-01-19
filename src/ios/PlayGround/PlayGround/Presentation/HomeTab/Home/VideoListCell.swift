//
//  VideoListCell.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/28.
//

import Foundation
import UIKit

class VideoListCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var viewLabel: UILabel!
    @IBOutlet weak var liveSign: UIImageView!
    @IBOutlet weak var playView: UIView!
    var channelTapHandler: (()->Void)?
    
    func setupUI(_ index: Int, _ current: Int) {
        titleLabel.font = UIFont.Component
        titleLabel.text = "\(index)번째 동영상"
        nicknameLabel.font = UIFont.caption
        nicknameLabel.textColor = UIColor.customDarkGray
        viewLabel.font = UIFont.caption
        viewLabel.textColor = UIColor.customDarkGray
        profileImageView.layer.cornerRadius = 33 / 2
        profileImageView.backgroundColor = UIColor.placeHolder
        liveSign.layer.cornerRadius = 3
//        if index == current {
//            playView.player?.play()
//        } else {
//            playView.player?.pause()
//        }
    }
    
    @IBAction func channelProfileDidTap(_ sender: Any) {
        channelTapHandler?()
    }
}
