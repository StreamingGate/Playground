//
//  HomeViewModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/28.
//

import Foundation
import UIKit
import Combine

class HomeViewModel {
    @Published var homeList: [GeneralVideo] = []
    @Published var selectedCategory = "ALL"
    var categories: [String] = []

    var lastLiveId = -1
    var lastVideoId = -1
    var isLoading = false
    var isFinished = false
    
    func loadAllList(vc: UIViewController, coordinator: Coordinator?) {
        isLoading = true
        MainServiceAPI.shared.getAllList(lastVideoId: lastVideoId, lastLiveId: lastLiveId, category: selectedCategory, size: (lastLiveId == -1 && lastVideoId == -1 ? 10 : 5)) { result in
            guard let data = NetworkResultManager.shared.analyze(result: result, vc: vc, coordinator: coordinator) as? HomeList else { return }
            var addedList = data.liveRooms
            addedList.append(contentsOf: data.videos)
            if self.lastVideoId == -1 && self.lastLiveId == -1 {
                self.homeList = addedList
            } else {
                self.homeList.append(contentsOf: addedList)
            }
            self.isFinished = (addedList.count == 0)
            self.isLoading = false
            self.categories = data.categories
            self.lastLiveId = data.liveRooms.last?.id ?? self.lastLiveId
            self.lastVideoId = data.videos.last?.id ?? self.lastVideoId
        }
    }
}
