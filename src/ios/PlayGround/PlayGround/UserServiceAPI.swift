//
//  UserServiceAPI.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/19.
//

import Foundation

struct UserServiceAPI {
    static let shared = UserServiceAPI()
    
    func register(email: String, name: String, nickName: String, password: String, profileImage: String, completion: @escaping (UserInfo)->Void) {
        let url = URL(string: "http://localhost:50001/users")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["email": email, "name" : name, "nickName": nickName, "password": password, "profileImage": profileImage]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("\(error?.localizedDescription ?? "no error") \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UserInfo.self, from: resultData)
                completion(response)
            } catch let error {
                print("---> error while register: \(error.localizedDescription)")
                return
            }
            
            
//            let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
//            if let result = responseJSON as? [String: Any] {
//                completion(result)
//            } else {
//                completion(["success" : 0])
//            }
        }
        task.resume()
    }
    
    func login(email: String, password: String, timezone: String, fcmtoken: String, completion: @escaping ([String:Any])->Void) {
        let url = URL(string: "http://localhost:50001/login")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["email": email, "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, let HeaderFields = (response as? HTTPURLResponse)?.allHeaderFields, let accessToken = HeaderFields["token"], let uuid = HeaderFields["uuid"], successRange.contains(statusCode), let _ = data else {
                print("\(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                completion(["success" :0])
                return
            }
            if statusCode == 200 {
                completion(["success" : 1, "accessToken": accessToken, "uuid": uuid])
            } else {
                completion(["success" :0])
            }
        }
        task.resume()
    }
    
    func sendEmailVerification(email: String, completion: @escaping (String)->Void) {
        let url = URL(string: "http://localhost:50001/users/email")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["email": email]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("\(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                completion("error")
                return
            }
            if let resultString = String(data: resultData, encoding: .utf8) {
                completion(resultString)
            } else {
                completion("error")
            }
        }
        task.resume()
    }
    
    func nicknameDuplicateCheck(nickname: String, completion: @escaping (Bool)->Void) {
        let original = "http://localhost:50001/nickname?nickname=\(nickname)"
        // 한글이 들어간 경우를 위해서
        guard let target = original.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            // 인코딩중 에러가 발생함
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
                completion(false)
                return
            }
            if let resultBoolean = String(data: resultData, encoding: .utf8).flatMap(Bool.init) {
                completion(resultBoolean)
            } else {
                completion(false)
            }
        }
        task.resume()
    }
    
    func checkVerificationCode(code: String, completion: @escaping (String)->Void) {
        let original = "http://localhost:50001/users/mail?code=\(code)"
        // 한글이 들어간 경우를 위해서
        guard let target = original.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            // 인코딩중 에러가 발생함
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
                completion("error")
                return
            }
            if let resultString = String(data: resultData, encoding: .utf8) {
                completion(resultString)
            } else {
                completion("error")
            }
        }
        task.resume()
    }
    
//    func getChannelInfo(uuid: String, completion: @escaping ([String: Any])->Void) {
//        let session = URLSession(configuration: .ephemeral)
//        let urlComponents = URLComponents(string: "http://localhost:50001/users/\(uuid)")!
//        print("url : \(urlComponents.url!)")
//        let requestURL = urlComponents.url!
//        let task = session.dataTask(with: requestURL) { data, response, error in
//            let successRange = 200 ..< 300
//            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
//                print("\(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
//                completion(["success" :0])
//                return
//            }
//            let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
//            if let result = responseJSON as? [String: Any] {
//                completion(result)
//            } else {
//                completion(["success" :0])
//            }
//        }
//        task.resume()
//    }
    
    
}
