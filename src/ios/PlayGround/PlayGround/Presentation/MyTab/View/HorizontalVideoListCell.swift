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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.backgroundColor = UIColor.black
        titleLabel.font = UIFont.caption
        explainLabel1.font = UIFont.caption
        explainLabel1.textColor = UIColor.customDarkGray
        explainLabel2.font = UIFont.caption
        explainLabel2.textColor = UIColor.customDarkGray
    }
    
    /**
     실시간 스트리밍 UI 세팅
     */
    func setupLive(info: GeneralVideo) {
        titleLabel.text = info.title
        explainLabel1.text = info.hostNickname
        guard let uuid = info.uuid else { return }
        explainLabel2.text = "\(String(describing: info.hits))회"
        thumbnailImageView.downloadImageFrom(link: "https://d8knntbqcc7jf.cloudfront.net/thumbnail/\(uuid)", contentMode: .scaleAspectFit)
        explainLabel1.text = "\(info.hostNickname ?? "익명") •"
    }
    
    /**
     업로드된 비디오 UI 세팅
     */
    func setupVideo(info: GeneralVideo) {
        titleLabel.text = info.title
        thumbnailImageView.downloadImageFrom(link: info.thumbnail, contentMode: .scaleAspectFit)
        explainLabel2.text = "\(String(describing: info.hits ?? 0))회"
        explainLabel1.text = "\(info.uploaderNickname ?? "익명") •"
    }
    
    /**
     내가 업로드한 비디오 UI 세팅
     */
    func setupUploadedVideo(info: GeneralVideo) {
        titleLabel.text = info.title
        thumbnailImageView.downloadImageFrom(link: info.thumbnail, contentMode: .scaleAspectFit)
        explainLabel1.text = "\(String(describing: info.hits ?? 0))회 •"
        guard let create = info.createdAt else { return }
        explainLabel2.text = create.getDateString()
    }
}
