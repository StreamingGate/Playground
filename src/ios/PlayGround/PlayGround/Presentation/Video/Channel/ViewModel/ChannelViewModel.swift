//
//  ChannelViewModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/15.
//

import Foundation
import UIKit
import Combine

class ChannelViewModel {
    @Published var currentChannel: ChannelInfo?
    @Published var videoList: [GeneralVideo]?
    
    var isLoading = false
    var lastId = -1
    var isFinished = false
    
    func loadChannelInfo(uuid: String) {
        UserServiceAPI.shared.getChannelInfo(targetUuid: uuid) { result in
            guard let info = result["data"] as? ChannelInfo else { return }
            self.currentChannel = info
        }
    }
    
    func loadVideo(vc: UIViewController, coordinator: Coordinator?) {
        self.isLoading = true
        guard let info = currentChannel else { return }
        UserServiceAPI.shared.getUploaded(lastVideoId: self.lastId, size: self.lastId == -1 ? 10 : 5, uuid: info.uuid) { result in
            self.isLoading = false
            guard let data = NetworkResultManager.shared.analyze(result: result, vc: vc, coordinator: coordinator) as? [GeneralVideo] else { return }
            print("current ==> \(data)")
            self.isFinished = (data.count == 0)
            self.lastId = data.last?.id ?? self.lastId
            self.videoList = data
        }
    }
}
