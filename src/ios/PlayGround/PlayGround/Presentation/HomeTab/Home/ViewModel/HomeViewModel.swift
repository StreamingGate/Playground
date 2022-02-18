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
    @Published var homeList: [GeneralVideo]?
    @Published var selectedCategory = "ALL"
    var categories: [String] = []

    // 불러온 데이터가 없을 경우 -1 부여
    // 인피니트 스크롤을 위해서 현재 가져온 실시간 스트리밍과 비디오의 마지막 id를 보냄
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
                // 본 카테고리의 데이터를 처음 불러온 경우, homeList 초기화
                self.homeList = addedList
            } else {
                if self.homeList == nil {
                    self.homeList = addedList
                } else {
                    self.homeList?.append(contentsOf: addedList)
                }
            }
            self.isFinished = (addedList.count == 0)
            self.isLoading = false
            self.categories = data.categories
            
            // 불러온 데이터가 없을 경우, 현재 마지막 id 유지
            self.lastLiveId = data.liveRooms.last?.id ?? self.lastLiveId
            self.lastVideoId = data.videos.last?.id ?? self.lastVideoId
        }
    }
}
