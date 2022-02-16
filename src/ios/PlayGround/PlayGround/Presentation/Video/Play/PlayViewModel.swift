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
    
    // 홈화면 등에서 general한 데이터(GeneralVideo)를 받아온 후,
    // 자세한 개별 정보 (실시간 스트리밍(roomInfo) 혹은 동영상(VideoInfo))를 가져옴
    @Published var currentInfo: GeneralVideo?
    @Published var videoInfo: VideoInfo?
    @Published var roomInfo: RoomInfo?
    @Published var userCount: Int = 0
    
    var videoId: Int? {
        guard let info = self.currentInfo else { return nil }
        return info.id
    }
    
    var isLive: Bool {
        guard let info = currentInfo else { return false }
        return (info.hostNickname != nil)
    }
    
    func loadSingleInfo(vc: UIViewController, coordinator: Coordinator?) {
        guard let id = videoId else { return }
        if isLive {
            RoomServiceAPI.shared.loadRoom(roomId: id) { result in
                guard let data = NetworkResultManager.shared.analyze(result: result, vc: vc, coordinator: coordinator) as? RoomInfo else { return }
                self.roomInfo = data
                self.isLiked = data.liked
                self.isDisliked = data.disliked
                self.likeCount = data.likeCnt
            }
        } else {
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
