//
//  UploadServiceAPI.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/02/05.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

struct UploadServiceAPI {
    static let shared = UploadServiceAPI()
    let uploadServiceUrl = "http://\(GatewayManager.shared.gatewayAddress)/upload-service"
    
    func post(video: Data, image: Data?, title: String, content: String, category: String, completion: @escaping ([String:Any])->Void){
        let urlPath = "\(uploadServiceUrl)/upload"
        guard let endpoint = URL(string: urlPath) else {
                print("Error creating endpoint")
                return
        }
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue), let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        var request = URLRequest(url: endpoint, timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"data\"\r\nContent-Type: application/json\r\n\r\n")
        let dataInfo = "{\n\"title\":\"\(title)\",\n\"content\":\"\(content)\",\n\"category\":\"\(category)\",\n\"uuid\":\"\(uuid)\"\n}"
        body.appendString("\(dataInfo)\r\n")
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"video\"; filename=\"video.mp4\"\r\n")
        body.appendString("Content-Type: video/mp4\r\n\r\n")
        body.append(video)
        body.appendString("\r\n")
        
        if let imageInfo = image {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"thumbnail\"; filename=\"thumbnail.png\"\r\n")
            body.appendString("Content-Type: image/png\r\n\r\n")
            body.append(imageInfo)
            body.appendString("\r\n")
        }

        body.appendString("--\(boundary)--\r\n")
        
        request.setValue("\(String(describing: body.count))", forHTTPHeaderField: "Content-Length")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        request.httpBody = body as Data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print("start data task")
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
                completion(responseJSON)
            }
        }
        task.resume()
    }
}

extension NSMutableData {
    func appendString(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
