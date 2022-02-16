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
        thumbnailImageView.backgroundColor = UIColor.black
        titleLabel.font = UIFont.caption
        channelNicknameLabel.font = UIFont.caption
        channelNicknameLabel.textColor = UIColor.customDarkGray
    }
    
    /**
     실시간 스트리밍 UI 세팅
     */
    func setupLive(info: GeneralVideo) {
        titleLabel.text = info.title
        channelNicknameLabel.text = "\(info.hostNickname ?? "익명")"
//        liveSign.isHidden = false
        guard let uuid = info.uuid else { return }
        thumbnailImageView.downloadImageFrom(link: "https://d8knntbqcc7jf.cloudfront.net/thumbnail/\(uuid)", contentMode: .scaleAspectFit)
    }
    
    /**
     업로드된 비디오 UI 세팅
     */
    func setupVideo(info: GeneralVideo) {
        titleLabel.text = info.title
//        liveSign.isHidden = true
        thumbnailImageView.downloadImageFrom(link: info.thumbnail, contentMode: .scaleAspectFit)
        channelNicknameLabel.text = "\(info.uploaderNickname ?? "익명")"
    }
}
