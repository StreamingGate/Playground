//
//  MyHistoryViewModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/14.
//

import Foundation
import UIKit
import Combine
import SwiftKeychainWrapper

class MyHistoryViewModel {
    @Published var myList: [GeneralVideo] = []

    // 불러온 데이터가 없을 경우 -1 부여
    // 인피니트 스크롤을 위해서 현재 가져온 실시간 스트리밍과 비디오의 마지막 id를 보냄
    var lastLive = "null"
    var lastVideo = "null"
    var isLoading = false
    var isFinished = false
    
    var lastUploaded = -1
    
    func loadUploadedist(vc: UIViewController, coordinator: Coordinator?) {
        isLoading = true
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        UserServiceAPI.shared.getUploaded(lastVideoId: lastUploaded, size: (lastUploaded == -1 ? 10 : 5), uuid: uuid) { result in
            guard let data = NetworkResultManager.shared.analyze(result: result, vc: vc, coordinator: coordinator) as? [GeneralVideo] else { return }
            if self.lastUploaded == -1 {
                // 본 카테고리의 데이터를 처음 불러온 경우, homeList 초기화
                self.myList = data
            } else {
                self.myList.append(contentsOf: data)
            }
            self.isFinished = (data.count == 0)
            self.isLoading = false
            print("my list ---> \(self.myList)")
            // 불러온 데이터가 없을 경우, 현재 마지막 id 유지
            self.lastUploaded = data.last?.id ?? self.lastUploaded
        }
    }
    
    func loadLikedList(vc: UIViewController, coordinator: Coordinator?) {
        isLoading = true
        UserServiceAPI.shared.getLiked(lastVideo: lastVideo, lastLive: lastLive, size: (lastLive == "null" && lastVideo == "null" ? 10 : 5)) { result in
            guard let data = NetworkResultManager.shared.analyze(result: result, vc: vc, coordinator: coordinator) as? HomeList else { return }
            var addedList = data.liveRooms
            addedList.append(contentsOf: data.videos)
            if self.lastLive == "null" && self.lastVideo == "null" {
                // 본 카테고리의 데이터를 처음 불러온 경우, homeList 초기화
                self.myList = addedList
            } else {
                self.myList.append(contentsOf: addedList)
            }
            self.isFinished = (addedList.count == 0)
            self.isLoading = false
            print("my list ---> \(self.myList)")
            // 불러온 데이터가 없을 경우, 현재 마지막 id 유지
            self.lastLive = data.liveRooms.last?.likedAt ?? self.lastLive
            self.lastVideo = data.videos.last?.likedAt ?? self.lastVideo
        }
    }
    
    func loadWachedList(vc: UIViewController, coordinator: Coordinator?) {
        isLoading = true
        UserServiceAPI.shared.getWatched(lastVideo: lastVideo, lastLive: lastLive, size: (lastLive == "null" && lastVideo == "null" ? 10 : 5)) { result in
            guard let data = NetworkResultManager.shared.analyze(result: result, vc: vc, coordinator: coordinator) as? HomeList else { return }
            var addedList = data.liveRooms
            addedList.append(contentsOf: data.videos)
            if (self.lastLive == "null" && self.lastVideo == "null") {
                self.myList = addedList
            } else {
                self.myList.append(contentsOf: addedList)
            }
            self.isFinished = (addedList.count == 0)
            self.isLoading = false
            print("my list ---> \(self.myList.count)")
            // 불러온 데이터가 없을 경우, 현재 마지막 id 유지
            self.lastLive = data.liveRooms.last?.lastViewedAt ?? self.lastLive
            self.lastVideo = data.videos.last?.lastViewedAt ?? self.lastVideo
        }
    }
}
