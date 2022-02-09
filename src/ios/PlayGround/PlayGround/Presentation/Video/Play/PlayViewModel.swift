//
//  PlayViewModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/01.
//

import Foundation
import UIKit
import Combine

class PlayViewModel {
    let categoryDic = ["ALL": "전체", "EDU": "교육", "SPORTS": "스포츠", "KPOP": "K-POP"]
    
    @Published var isLiked: Bool?
    @Published var isDisliked: Bool?
    @Published var likeCount = 0
    
    @Published var currentInfo: GeneralVideo?
    @Published var videoInfo: VideoInfo?
    var videoId: Int? {
        guard let info = self.currentInfo else { return nil }
        return info.id
    }
    
    var isLive: Bool {
        guard let info = currentInfo else {
            return false
        }
        return (info.hostNickname != nil)
    }
    
    func loadSingleInfo(vc: UIViewController, coordinator: Coordinator?) {
        if isLive {
            print("room-service 추가 예정")
        } else {
            guard let id = videoId else { return }
            VideoServiceAPI.shared.loadSingleVideo(videoId: id) { result in
                guard let data = NetworkResultManager.shared.analyze(result: result, vc: vc, coordinator: coordinator) as? VideoInfo else { return }
                self.videoInfo = data
                self.isLiked = data.liked
                self.isDisliked = data.disliked
                self.likeCount = data.likeCnt
            }
        }
    }
}
