//
//  VideoListCell.swift
//  SG_YouTube
//
//  Created by chuiseo-MN on 2021/12/28.
//

import Foundation
import UIKit

/**
 동영상 리스트를 보여주는 셀
 */
class VideoListCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var liveSign: UIImageView!
    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    var channelTapHandler: (()->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImageView.layer.cornerRadius = 33 / 2
    }
    
    func setupUI(_ index: Int) {
        titleLabel.font = UIFont.Component
        nicknameLabel.font = UIFont.caption
        nicknameLabel.textColor = UIColor.customDarkGray
        profileImageView.layer.cornerRadius = 33 / 2
        profileImageView.backgroundColor = UIColor.placeHolder
        liveSign.layer.cornerRadius = 3
    }
    
    /**
     실시간 스트리밍 UI 세팅
     */
    func setupLive(info: GeneralVideo) {
        thumbnailImageView.image = nil
        titleLabel.text = info.title
        nicknameLabel.text = info.hostNickname
        liveSign.isHidden = false
        guard let create = info.createdAt, let uuid = info.uuid, let nickname = info.hostNickname else { return }
        nicknameLabel.text = "\(nickname) • \(create.getDateString())"
        thumbnailImageView.downloadImageFrom(link: "https://d8knntbqcc7jf.cloudfront.net/thumbnail/\(uuid)", contentMode: .scaleAspectFit)
    }
    
    /**
     업로드된 비디오 UI 세팅
     */
    func setupVideo(info: GeneralVideo) {
        thumbnailImageView.image = nil
        titleLabel.text = info.title
        liveSign.isHidden = true
        thumbnailImageView.downloadImageFrom(link: info.thumbnail, contentMode: .scaleAspectFit)
        guard let create = info.createdAt, let nickname = info.uploaderNickname else { return }
        nicknameLabel.text = "\(nickname) • 조회수 \(info.hits ?? 0)회 • \(create.getDateString())"
    }
    
    @IBAction func channelProfileDidTap(_ sender: Any) {
        channelTapHandler?()
    }
}
