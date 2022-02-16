//
//  ChatServiceAPI.swift
//  PlayGround
//
//  Created by chuiseo-MN on 2022/01/26.
//

import Foundation
import StompClientLib
import SwiftKeychainWrapper

class ChatServiceAPI {
    static let shared = ChatServiceAPI()
    var socketClient = StompClientLib()
    let chatServiceUrl = "ws://localhost:8888/ws/websocket"
    
    func connectToSocket(viewModel: ChatViewModel) {
        guard let tokenInfo = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.accessToken.rawValue), let url = NSURL(string: chatServiceUrl) else { return }
//        socketClient.certificateCheckEnabled = false
        socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: viewModel, connectionHeaders: ["hear-beat": "10000,10000", "accept-version":"1.1,1.0", "token": tokenInfo])
    }
    
    func enterRoom(roomId: String) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        socketClient.subscribeWithHeader(destination: "/topic/chat/enter/\(roomId)", header: ["uuid": uuid])
        socketClient.subscribe(destination: "/topic/chat/room/\(roomId)")
    }
    
    func disconnectToSocketWithHeader(header: [String: String]) {
        socketClient.disconnectWithHeader(header: header)
    }
    
    func disconnectToSocket() {
        socketClient.disconnect()
    }
    
    func loadInitialChat(uuid: String, completion: @escaping (([String: Any])->Void)) {
        let original = "http://10.99.6.93:8888/chat/room/\(uuid)"
        
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
                let response = try decoder.decode(ChatInitialData.self, from: resultData)
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
    
    /**
     채팅 전송
     - Parameters:
        - roomId: chatting room id
        - nickname: user nickname
        - role: user role
        - type: message type (NORMAL/PINNED)
        - message: message content
     */
    func sendMessage(roomId: String, nickname: String, role: String, type: String, message: String) {
        guard let uuid = KeychainWrapper.standard.string(forKey: KeychainWrapper.Key.uuid.rawValue) else { return }
        socketClient.sendJSONForDict(dict: ["roomUuid": roomId, "uuid": uuid, "nickname": nickname, "senderRole" : role, "chatType" : type, "message" : message] as NSDictionary, toDestination: "/app/chat/message/\(roomId)")
    }
    
    }
}
