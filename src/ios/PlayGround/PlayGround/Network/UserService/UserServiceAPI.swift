//
//  UserServiceAPI.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/19.
//

import Foundation

struct UserServiceAPI {
    static let shared = UserServiceAPI()
    let userServiceUrl = "http://\(GatewayManager.shared.gatewayAddress)/user-service"
    
    /**
     회원가입
     - Parameters:
        - email: user email address
        - name: user name
        - nickName: user nickname
        - password: password
        - profileImage: binary string of imageData
     */
    func register(email: String, name: String, nickName: String, password: String, profileImage: String, completion: @escaping (UserInfo?)->Void) {
        let url = URL(string: "\(userServiceUrl)/users")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["email": email, "name" : name, "nickName": nickName, "password": password, "profileImage": profileImage]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("--> error while register: \(error?.localizedDescription ?? "no error") \((response as? HTTPURLResponse)?.statusCode ?? 0)")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UserInfo.self, from: resultData)
                completion(response)
            } catch let error {
                print("---> error while register: \(error.localizedDescription)")
                completion(nil)
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
    
    /**
     로그인
     - Parameters:
        - email: user email address
        - password: password
        - timezone: timezone info of user location
        - fcmtoken: token for notification
     */
    func login(email: String, password: String, timezone: String, fcmtoken: String, completion: @escaping ([String:Any])->Void) {
        let url = URL(string: "\(userServiceUrl)/login")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["email": email, "password": password]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, let HeaderFields = (response as? HTTPURLResponse)?.allHeaderFields, let accessToken = HeaderFields["token"], let uuid = HeaderFields["uuid"], successRange.contains(statusCode), let resultData = data else {
                print("---> error while login: \(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                completion(["success" : 0])
                return
            }
            if statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(UserInfo.self, from: resultData)
                    completion(["success" : 1, "accessToken": accessToken, "uuid": uuid, "data": response])
                } catch let error {
                    print("---> error while login: \(error.localizedDescription)")
                    completion(["success" : 0])
                    return
                }
            } else {
                completion(["success" :0])
            }
        }
        task.resume()
    }
    
    /**
     이메일 인증 보내기
     - Parameters:
        - email: user email address
     */
    func sendEmailVerification(email: String, completion: @escaping ([String: Any])->Void) {
        let url = URL(string: "\(userServiceUrl)/email")!
        var request = URLRequest(url: url)
        let postData : [String: Any] = ["email": email]
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("---> error while send email: \(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                completion(["email" : "failed"])
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
            if let result = responseJSON as? [String: Any] {
                completion(result)
            } else {
                completion(["email" : "failed"])
            }
        }
        task.resume()
    }
    
    /**
     이메일 인증코드 확인
     - Parameters:
        - code: code that sent to email verification
     */
    func checkVerificationCode(code: String, completion: @escaping ([String: Any])->Void) {
        let original = "\(userServiceUrl)/email?code=\(code)"
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
                print("---> error while check verification: \(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                completion(["email" : "failed"])
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
            if let result = responseJSON as? [String: Any] {
                completion(result)
            } else {
                completion(["email" : "failed"])
            }
        }
        task.resume()
    }
    
    /**
     닉네임 중복 확인
     - Parameters:
        - nickname: user nickname
     */
    func nicknameDuplicateCheck(nickname: String, completion: @escaping ([String: Any])->Void) {
        let original = "\(userServiceUrl)/nickname?nickname=\(nickname)"
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
                print("---> error while nickname duplicate check: \(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                completion(["nickName" : "failed"])
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: resultData, options: [])
            if let result = responseJSON as? [String: Any] {
                completion(result)
            } else {
                completion(["nickName" : "failed"])
            }
        }
        task.resume()
    }
    
    /**
     유저 정보 업데이트
     - Parameters:
        - nickName: updated user nickname
        - profileImage: binary string of updated user profile image data
     */
    func updateUserInfo(nickName: String?, profileImage: String?, completion: @escaping ([String: Any])->Void) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue), let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let url = URL(string: "\(userServiceUrl)/\(uuid)")!
        var request = URLRequest(url: url)
        var postData = [String: Any]()
        if let profile = profileImage {
            postData["profileImage"] = profile
        }
        if let nickname = nickName {
            postData["nickName"] = nickname
        }
        print(postData)
        let jsonData = try? JSONSerialization.data(withJSONObject: postData)
        request.httpMethod = "PUT"
        request.httpBody = jsonData
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(tokenInfo)", forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let successRange = 200 ..< 300
            guard error == nil, let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode), let resultData = data else {
                print("---> error while update userInfo: \(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 401 {
                    completion(["result": "Invalid Token"])
                    return
                }
                completion(["result": "failed"])
                return
            }
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(UserInfo.self, from: resultData)
                completion(["result": "success", "data": response])
            } catch let error {
                print("---> error while update userInfo: \(error.localizedDescription)")
                completion(["result": "failed"])
                return
            }
        }
        task.resume()
    }
    
    /**
     업로드 동영상 조회
     - Parameters:
        - lastVideoId: last id of video for infinite scroll
        - lastLiveId: last id of live for infinite scroll
        - size: size to bring
     */
    func getUploaded(lastVideoId: Int, size: Int, uuid: String, completion: @escaping ([String: Any])->Void) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let original = "\(userServiceUrl)/upload/\(uuid)/?last-video=\(lastVideoId)&size=\(size)"
        
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
                print("---> error while loading uploaded list: \(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
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
                let response = try decoder.decode([GeneralVideo].self, from: resultData)
                completion(["result": "success", "data": response])
            } catch let error {
                print("---> error while loading uploaded list: \(error.localizedDescription)")
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
    
    func getWatched(lastVideo: String, lastLive: String, size: Int, completion: @escaping ([String: Any])->Void) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue), let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let original = "\(userServiceUrl)/watch/\(uuid)/?last-video=\(lastVideo)&last-live=\(lastLive)&size=\(size)"
        print("~~~~~~> \(original)")
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
                print("---> error while loading watched list: \(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
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
                print("---> error while loading watched list: \(error.localizedDescription)")
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
    
    func getLiked(lastVideo: String, lastLive: String, size: Int, completion: @escaping ([String: Any])->Void) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue), let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else {
            completion(["result": "Invalid Token"])
            return
        }
        let original = "\(userServiceUrl)/liked/\(uuid)/?last-video=\(lastVideo)&last-live=\(lastLive)&size=\(size)"
        
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
                print("---> error while loading liked list: \(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
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
                print("---> error while loading liked list: \(error.localizedDescription)")
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
    
    func getChannelInfo(targetUuid: String, completion: @escaping ([String: Any])->Void) {
        let original = "\(userServiceUrl)/\(targetUuid)"
        
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
                print("---> error while loading channel info: \(error?.localizedDescription ?? "no error") \(String(describing: (response as? HTTPURLResponse)?.statusCode))")
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
                let response = try decoder.decode(ChannelInfo.self, from: resultData)
                completion(["result": "success", "data": response])
            } catch let error {
                print("---> error while loading channel info: \(error.localizedDescription)")
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
