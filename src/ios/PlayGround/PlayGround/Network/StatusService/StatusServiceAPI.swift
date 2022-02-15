//
//  StatusServiceAPI.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/14.
//

import Foundation
import StompClientLib
import SwiftKeychainWrapper

class StatusServiceAPI {
    static let shared = StatusServiceAPI()
    
    var socketClient = StompClientLib()
    let statusServiceUrl = "ws://10.99.6.93:9999/ws/websocket"
    
    func connectToSocket(manager: StatusManager) {
        guard let token = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else { return }
        let url = NSURL(string: self.statusServiceUrl)!
//        socketClient.certificateCheckEnabled = false
        self.socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL), delegate: manager, connectionHeaders: ["token": token])
    }
    
    func getFriendInfo(completion: @escaping ([String: Any])->Void) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue), let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let original = "http://10.99.6.93:9999/list?uuid=\(uuid)"
        guard let target = original.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("error encoding")
            return
        }
        let session = URLSession(configuration: .ephemeral)
        let urlComponents = URLComponents(string: target)!
        let requestURL = urlComponents.url!
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("\(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 401 {
                    completion(["result": "Invalid Token"])
                    return
                }
                completion(["result": "failed"])
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970
                let response = try decoder.decode(FriendWatchList.self, from: resultData)
                completion(["result": "success", "data": response])
            } catch let error {
                print("---> error while loading status list: \(error.localizedDescription)")
                let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
                if let result = responseJSON as? [String: Any] {
                    completion(result)
                } else {
                    completion(["result": "failed"])
                }
            }
        }
        dataTask.resume()
    }
    
    func connectLogin(uuid: String) {
        socketClient.subscribe(destination: "/topic/friends/\(uuid)")
    }
    
    func disconnectToSocket() {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        socketClient.disconnectWithHeader(header: ["uuid": uuid])
        
    }
    
    /**
     현재 시청 중인 비디오 정보 전송
     - Parameters:
        - id: videoId or liveRoomId (pk value)
        - type: video - 0, live - 1
        - videoRoomUuid: video or liveRoom uuid
        - title: video or liveRoom title
     */
    func startWatchingVideo(id: Int, type: Int, videoRoomUuid: String, title: String) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        socketClient.sendJSONForDict(dict: ["id": id, "type": type, "videoRoomUuid": videoRoomUuid, "title" : title] as NSDictionary, toDestination: "/app/watch/\(uuid)")
    }
    
    /**
     시청 중단
     */
    func stopWatchingVideo() {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        socketClient.sendJSONForDict(dict: [:] as NSDictionary, toDestination: "/app/watch/\(uuid)")
    }
}
