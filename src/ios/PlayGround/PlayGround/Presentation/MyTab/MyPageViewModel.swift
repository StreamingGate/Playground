//
//  MyPageViewModel.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/14.
//

import Foundation
import Combine

class MyPageViewModel {
    @Published var myList: [GeneralVideo] = []
    
    func loadWachedList(vc: UIViewController, coordinator: Coordinator?) {
        UserServiceAPI.shared.getWatched(lastVideoId: -1, lastLiveId: -1, size: 10) { result in
            guard let data = NetworkResultManager.shared.analyze(result: result, vc: vc, coordinator: coordinator) as? HomeList else { return }
            var addedList = data.liveRooms
            addedList.append(contentsOf: data.videos)
            self.myList = addedList
        }
    }
}
