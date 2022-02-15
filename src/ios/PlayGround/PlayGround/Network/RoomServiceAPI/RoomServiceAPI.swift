//
//  RoomServiceAPI.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/09.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

struct RoomServiceAPI {
    
    static let shared = RoomServiceAPI()
    let roomServiceUrl = "http://\(GatewayManager.shared.gatewayAddress)/room-service"
    
    /**
     실시간 스트리밍 시작 전 DB에 방 정보 추가
     - Parameters:
        - uuid: room identifier
        - title: room title
        - content: room explanation
        - thumbnail: binary string of image data
        - category: room category
     */
    func createRoom(uuid: String, title: String, content: String, thumbnail: String, category: String, completion: @escaping ([String: Any])->Void) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue), let hostUuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let url = URL(string: "\(roomServiceUrl)/room")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["hostUuid": hostUuid, "uuid": uuid, "title": title, "content": content, "thumbnail": thumbnail, "category": category]
        print("--> \(postData)")
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("room service create: \(error?.localizedDescription ?? "no error") \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 401 {
                    completion(["result": "Invalid Token"])
                    return
                }
                completion(["result": "failed"])
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
            if let result = responseJSON as? [String: Any] {
                print("result: \(result)")
                completion(["result": "success", "data": result])
            } else {
                completion(["result": "failed"])
            }
        }
        task.resume()
    }
    
    /**
     실시간 스트리밍 방 정보 한 개 가져오기
     - Parameters:
        - roomId: room uuid
     */
    func loadRoom(roomId: Int, completion: @escaping ([String: Any])->Void) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue), let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let original = "\(roomServiceUrl)/room?roomId=\(roomId)&uuid=\(uuid)"
        print("===> \(original)")
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
        
        let task = session.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("load room-service: \(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
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
                let response = try decoder.decode(RoomInfo.self, from: resultData)
                print("room servicee: \(response)")
                completion(["result": "success", "data": response])
            } catch let error {
                print("---> error while loading single video: \(error.localizedDescription)")
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
