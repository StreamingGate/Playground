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
    
    func loadAllList() {
        MainServiceAPI.shared.getAllList(lastVideoId: lastVideoId, lastLiveId: lastLiveId, category: selectedCategory) { result in
            if result["result"] as? String == "success" {
                guard let data = result["data"] as? HomeList else { return }
                var addedList = data.liveRooms
                addedList.append(contentsOf: data.videos)
                self.homeList = addedList
                self.categories = data.categories
                self.lastLiveId = data.liveRooms.last?.id ?? -1
                self.lastVideoId = data.videos.last?.id ?? -1
            }
        }
    }
}
