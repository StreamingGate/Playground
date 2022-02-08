//
//  VideoServiceAPI.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/08.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

struct VideoServiceAPI {
    static let shared = VideoServiceAPI()
    
    let videoServiceUrl = "http://\(GatewayManager.shared.gatewayAddress)/video-service"
    
    func loadSingleVideo(videoId: Int, completion: @escaping ([String: Any])->Void) {
        
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue), let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let original = "\(videoServiceUrl)/video/\(videoId)?uuid=\(uuid)"
        
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
                let response = try decoder.decode(VideoInfo.self, from: resultData)
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
