//
//  MainServiceAPI.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/28.
//

import Foundation
import UIKit

struct MainServiceAPI {
    static let shared = MainServiceAPI()
    
    let mainServiceUrl = "http://\(GatewayManager.shared.gatewayAddress)/main-service"
    
    func getAllList(lastVideoId: Int, lastLiveId: Int, category: String, completion: @escaping ([String: Any])->Void) {
        let original = "\(mainServiceUrl)/list?last-video=\(lastVideoId)&last-live=\(lastLiveId)&size=5&category=\(category)"
        
        guard let target = original.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("error encoding")
            return
        }
        
        let session = URLSession(configuration: .ephemeral)
        let urlComponents = URLComponents(string: target)!
        let requestURL = urlComponents.url!
        let task = session.dataTask(with: requestURL) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("\(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                completion(["result" : 0])
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970
                let response = try decoder.decode(HomeList.self, from: resultData)
                completion(["result": 1, "data": response])
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
}
