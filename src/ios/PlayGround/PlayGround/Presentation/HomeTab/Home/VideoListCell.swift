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
    @IBOutlet weak var liveSign: UIImageView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    var channelTapHandler: (()->Void)?
    
    func setupUI(_ index: Int) {
        titleLabel.font = UIFont.Component
        nicknameLabel.font = UIFont.caption
        nicknameLabel.textColor = UIColor.customDarkGray
        profileImageView.layer.cornerRadius = 33 / 2
        profileImageView.backgroundColor = UIColor.placeHolder
        liveSign.layer.cornerRadius = 3
    }
    
    func setupLive(info: GeneralVideo) {
        titleLabel.text = info.title
        nicknameLabel.text = info.hostNickname
        liveSign.isHidden = false
        thumbnailImageView.downloadImageFrom(link: info.thumbnail, contentMode: .scaleAspectFit)
        guard let create = info.createdAt else { return }
        nicknameLabel.text = "\(info.hostNickname ?? "익명") • \(create.getDateString())"
    }
    
    func setupVideo(info: GeneralVideo) {
        titleLabel.text = info.title
        liveSign.isHidden = true
        thumbnailImageView.downloadImageFrom(link: info.thumbnail, contentMode: .scaleAspectFit)
        guard let create = info.createdAt else { return }
        nicknameLabel.text = "\(info.uploaderNickname ?? "익명") • 조회수 \(info.hits ?? 0)회 • \(create.getDateString())"
    }
    
    @IBAction func channelProfileDidTap(_ sender: Any) {
        channelTapHandler?()
    }
}
