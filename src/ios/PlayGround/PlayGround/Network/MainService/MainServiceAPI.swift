//
//  MainServiceAPI.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/28.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

struct MainServiceAPI {
    static let shared = MainServiceAPI()
    let mainServiceUrl = "http://\(GatewayManager.shared.gatewayAddress)/main-service"
    
    /**
     홈에서 보이는 영상/실시간 리스트 가져오기
     - Parameters:
        - lastVideoId: last id of video for infinite scroll
        - lastLiveId: last id of live for infinite scroll
        - category: category to bring
        - size: size to bring
     */
    func getAllList(lastVideoId: Int, lastLiveId: Int, category: String, size: Int, completion: @escaping ([String: Any])->Void) {
        let original = "\(mainServiceUrl)/list?last-video=\(lastVideoId)&last-live=\(lastLiveId)&size=\(size)&category=\(category)"
        
        guard let target = original.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("error encoding")
            return
        }
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let session = URLSession(configuration: .ephemeral)
        let urlComponents = URLComponents(string: target)!
        let requestURL = urlComponents.url!
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
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
                let response = try decoder.decode(HomeList.self, from: resultData)
                completion(["result": "success", "data": response])
            } catch let error {
                print("---> error while loading home list: \(error.localizedDescription)")
                let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
                if let result = responseJSON as? [String: Any] {
                    completion(result)
                } else {
                    completion(["result": "failed"])
                }
            }
        }
        task.resume()
    }
    
    /**
     좋아요/싫어요/신고 버튼
     - Parameters:
        - videoId: id of selected video
        - type: 0 for video, 1 for live
        - action: like, dislike, report
        - uuid: user uuid
     */
    func tapButtons(videoId: Int, type: Int, action: Action, uuid: String, completion: @escaping ([String: Any])->Void) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let url = URL(string: "\(mainServiceUrl)/action")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["id": videoId, "type" : type, "action": action.rawValue, "uuid": uuid]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("\(error?.localizedDescription ?? "no error") \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 401 {
                    completion(["result": "Invalid Token"])
                    return
                }
                completion(["result": "failed"])
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
            if let result = responseJSON as? [String: Any] {
                completion(["result": "success", "data": result])
            } else {
                completion(["result": "failed"])
            }
        }
        task.resume()
    }
    
    /**
     좋아요/싫어요/신고 버튼 취소
     - Parameters:
        - videoId: id of selected video
        - type: 0 for video, 1 for live
        - action: like, dislike, report
        - uuid: user uuid
     */
    func cancelButtons(videoId: Int, type: Int, action: Action, uuid: String, completion: @escaping ([String: Any])->Void) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let url = URL(string: "\(mainServiceUrl)/action")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["id": videoId, "type" : type, "action": action.rawValue, "uuid": uuid]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "DELETE"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("\(error?.localizedDescription ?? "no error") \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 401 {
                    completion(["result": "Invalid Token"])
                    return
                }
                completion(["result": "failed"])
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
            if let result = responseJSON as? [String: Any] {
                completion(["result": "success", "data": result])
            } else {
                completion(["result": "failed"])
            }
        }
        task.resume()
    }
    
    /**
     알림 가져오기
     - Parameters:
        - uuid: user uuid
     */
    func loadNotifications(uuid: String, completion: @escaping ([String: Any])->Void) {
        let original = "\(mainServiceUrl)/notification/\(uuid)"
        
        guard let target = original.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("error encoding")
            return
        }
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let session = URLSession(configuration: .ephemeral)
        let urlComponents = URLComponents(string: target)!
        let requestURL = urlComponents.url!
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
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
                let response = try decoder.decode(NoticeResult.self, from: resultData)
                completion(["result": "success", "data": response.result])
            } catch let error {
                print("---> error while loading notification: \(error.localizedDescription)")
                let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
                if let result = responseJSON as? [String: Any] {
                    completion(result)
                } else {
                    completion(["result": "failed"])
                }
            }
        }
        task.resume()
    }
    
    /**
     친구 목록 가져오기
     - Parameters:
        - uuid: user uuid
     */
    func loadFriends(uuid: String, completion: @escaping ([String: Any])->Void) {
        let original = "\(mainServiceUrl)/friends/\(uuid)"
        
        guard let target = original.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("error encoding")
            return
        }
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let session = URLSession(configuration: .ephemeral)
        let urlComponents = URLComponents(string: target)!
        let requestURL = urlComponents.url!
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")

        let task = session.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("--> error while loading friends: \(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
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
                let response = try decoder.decode(FriendResult.self, from: resultData)
                completion(["result": "success", "data": response.result])
            } catch let error {
                print("---> error while loading friends: \(error.localizedDescription)")
                let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
                if let result = responseJSON as? [String: Any] {
                    completion(result)
                } else {
                    completion(["result": "failed"])
                }
            }
        }
        task.resume()
    }
    
    /**
     친구 신청 보내기
     - Parameters:
        - uuid: user uuid
        - target: uuid of target that the user wants to send friend request
     */
    func sendFriendRequest(uuid: String, target: String, completion: @escaping ([String: Any])->Void) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let url = URL(string: "\(mainServiceUrl)/friends/\(uuid)")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["target": target]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("--> error while sending friend requeest: \(error?.localizedDescription ?? "no error") \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 401 {
                    completion(["result": "Invalid Token"])
                    return
                }
                completion(["result": "failed"])
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
            if let result = responseJSON as? [String: Any] {
                print("---> friend Request: \(result)")
                completion(["result": "success", "data": result])
            } else {
                completion(["result": "failed"])
            }
        }
        task.resume()
    }
    
    /**
     친구 삭제하기
     - Parameters:
        - uuid: user uuid
        - target: uuid of target that the user wants to delete from friend list
     */
    func deleteFriend(uuid: String, target: String, completion: @escaping ([String: Any])->Void) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let url = URL(string: "\(mainServiceUrl)/friends/\(uuid)")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["target": target]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "DELETE"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("\(error?.localizedDescription ?? "no error") \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 401 {
                    completion(["result": "Invalid Token"])
                    return
                }
                completion(["result": "failed"])
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
            if let result = responseJSON as? [String: Any] {
                completion(["result": "success", "data": result])
            } else {
                completion(["result": "failed"])
            }
        }
        task.resume()
    }
    
    /**
     친구 요청 목록 가져오기
     - Parameters:
        - uuid: user uuid
     */
    func loadFriendRequests(uuid: String, completion: @escaping ([String: Any])->Void) {
        let original = "\(mainServiceUrl)/friends/manage/\(uuid)"
        
        guard let target = original.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("error encoding")
            return
        }
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let session = URLSession(configuration: .ephemeral)
        let urlComponents = URLComponents(string: target)!
        let requestURL = urlComponents.url!
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
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
                let response = try decoder.decode(FriendResult.self, from: resultData)
                completion(["result": "success", "data": response.result])
            } catch let error {
                print("---> error while loading friend requests: \(error.localizedDescription)")
                let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
                if let result = responseJSON as? [String: Any] {
                    completion(result)
                } else {
                    completion(["result": "failed"])
                }
            }
        }
        task.resume()
    }
    
    /**
     친구 요청 수락하기
     - Parameters:
        - myUUID: user uuid
        - friendUUID: uuid of friend that the user wants to accept friend request
     */
    func acceptFriendRequest(friendUUID: String, myUUID: String, completion: @escaping ([String: Any])->Void) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let url = URL(string: "\(mainServiceUrl)/friends/manage/\(myUUID)")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["sender": friendUUID]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("\(error?.localizedDescription ?? "no error") \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 401 {
                    completion(["result": "Invalid Token"])
                    return
                }
                completion(["result": "failed"])
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
            if let result = responseJSON as? [String: Any] {
                print("==> \(result)")
                completion(["result": "success", "data": result])
            } else {
                completion(["result": "failed"])
            }
        }
        task.resume()
    }
    
    /**
     친구 요청 거절하기
     - Parameters:
        - myUUID: user uuid
        - friendUUID: uuid of friend that the user wants to reject friend request
     */
    func deleteFriendRequest(friendUUID: String, myUUID: String, completion: @escaping ([String: Any])->Void) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let url = URL(string: "\(mainServiceUrl)/friends/manage/\(myUUID)")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["sender": friendUUID]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "DELETE"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("\(error?.localizedDescription ?? "no error") \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 401 {
                    completion(["result": "Invalid Token"])
                    return
                }
                completion(["result": "failed"])
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
            if let result = responseJSON as? [String: Any] {
                completion(["result": "success", "data": result])
            } else {
                completion(["result": "failed"])
            }
        }
        task.resume()
    }
    
    /**
     친구가 보고 있는 영상 조회하기
     - Parameters:
        - friendUUID: uuid of friend that the user wants to know which video he/she is watching
     */
    func loadFriendWatch(friendUUID: String, completion: @escaping ([String: Any])->Void) {
        
        let original = "\(mainServiceUrl)/friends/watch/\(friendUUID)"
        
        guard let target = original.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("error encoding")
            return
        }
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let session = URLSession(configuration: .ephemeral)
        let urlComponents = URLComponents(string: target)!
        let requestURL = urlComponents.url!
        var request = URLRequest(url: requestURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        
        let task = session.dataTask(with: request) { data, response, error in
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
                let response = try decoder.decode(WatchingInfo.self, from: resultData)
                completion(["result": "success", "data": response])
            } catch let error {
                print("---> error while loading friend requests: \(error.localizedDescription)")
                let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
                if let result = responseJSON as? [String: Any] {
                    completion(result)
                } else {
                    completion(["result": "failed"])
                }
            }
        }
        task.resume()
    }
}
