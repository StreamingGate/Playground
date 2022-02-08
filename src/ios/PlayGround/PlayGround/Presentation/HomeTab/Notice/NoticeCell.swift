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
        guard let content = parse(string: info.content) else { return }
        switch info.notiType {
        case "STREAMING":
            guard let sender = content["sender"] as? String, let profile = content["profileImage"] as? String else { return }
            noticeLabel.PartOfTextColorChange(fullText: "\(sender)님이 실시간 스트리밍을 시작했습니다  지금", changeText: "지금")
            profileImageView.downloadImageFrom(link: profile, contentMode: .scaleAspectFill)
        case "FRIEND_REQUEST":
            guard let sender = content["sender"] as? String, let profile = content["profileImage"] as? String else { return }
            noticeLabel.PartOfTextColorChange(fullText: "\(sender)님이 친구를 요청했습니다  지금", changeText: "지금")
            profileImageView.downloadImageFrom(link: profile, contentMode: .scaleAspectFill)
        default:
            guard let sender = content["sender"] as? String, let profile = content["profileImage"] as? String, let title = content["title"] as? String else { return }
            noticeLabel.PartOfTextColorChange(fullText: "\(sender)님이 '\(title)'에 좋아요를 눌렀습니다  지금", changeText: "지금")
            profileImageView.downloadImageFrom(link: profile, contentMode: .scaleAspectFill)
        }
    }
    
    
    func parse(string: String) -> [String: Any]? {
        let data = string.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String: Any] {
                print(jsonArray)
                return jsonArray
            } else {
                print("bad json")
                return nil
            }
        } catch let error as NSError {
            print(error)
            return nil
        }
    }
}
