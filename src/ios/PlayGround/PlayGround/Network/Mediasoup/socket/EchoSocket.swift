//
//  EchoSocket.swift
//  mediasoup-ios-cient-sample
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

import Foundation
import Starscream
import SwiftyJSON

public enum SocketError : Error {
    case INVALID_WS_URI
}

final internal class EchoSocket : WebSocketDelegate, MessageSubscriber {
    private var observers: [ObjectIdentifier : Observer] = [ObjectIdentifier : Observer]()
    
    private var socket: WebSocket?;
    
    func connect(wsUri: String) throws {
        if (self.socket != nil && self.socket?.isConnected ?? false) { return }
        var request = URLRequest(url:URL(string:wsUri)!)
        request.timeoutInterval = 5
        // protoo 서버에 연결을 위해 header 추가
        request.setValue("protoo", forHTTPHeaderField: "Sec-WebSocket-Protocol")
        self.socket = WebSocket(request:request)
        self.socket!.disableSSLCertValidation = true
        self.socket!.callbackQueue = DispatchQueue.global()
        self.socket!.delegate = self
        self.socket!.connect()
    }
        
    func send(message: String) {
        self.socket?.write(string: message)
    }
    
    func sendWithAck(message: [String: Any], completionHandler: @escaping (_: JSON) -> Void) {
        let event: String = message["method"] as? String ?? "event"
        DispatchQueue.global().async {
            let ackCall: AckCall = AckCall.init(event: event, socket: self)
            do {
                let data = try JSONSerialization.data(withJSONObject: message)
                if let dataString = String(data: data, encoding: .utf8){
                    let response: JSON = ackCall.sendAckRequest(message: dataString)
                    completionHandler(response)
                }
            } catch {
                print("JSON serialization failed: ", error)
            }
        }
    }
    
    func disconnect() {
        self.socket?.disconnect()
        self.socket = nil
    }
    
    func websocketDidConnect(socket: WebSocketClient) {
        print("websocketDidConnect")
        self.notifyObservers(event: ActionEvent.OPEN, data: nil)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("websocketDidReceiveData: \(data)")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("websocketDidDisconnect: \(String(describing: error?.localizedDescription))")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        print("websocketDisReceiveMessage " + text)
        let data: Data = text.data(using: .utf8)!
        let json: JSON = JSON.init(data)
        if json["method"].stringValue == "producerClose" {
            self.notifyObservers(event: "closed", data: json)
            return
        }
        let event: String = json["id"].stringValue
        self.notifyObservers(event: event, data: json)
    }
    
    func register(observer: MessageObserver) {
        let id: ObjectIdentifier = ObjectIdentifier(observer)
        self.observers[id] = Observer(observer: observer)
    }
    
    func unregister(observer: MessageObserver) {
        let id: ObjectIdentifier = ObjectIdentifier(observer)
        self.observers.removeValue(forKey: id);
    }
    
    func notifyObservers(event: String, data: JSON?) {
        for (id, observer) in self.observers {
            guard let observer = observer.observer else {
                self.observers.removeValue(forKey: id)
                continue
            }
            observer.on(event: event, data: data)
        }
    }
    
    private class AckCall {
        private let event: String
        private let semaphor: DispatchSemaphore
        private let socket: EchoSocket

        private var response: JSON?
        
        init(event: String, socket: EchoSocket) {
            self.event = event
            self.socket = socket
            self.semaphor = DispatchSemaphore.init(value: 0)
        }
        
        func sendAckRequest(message: String) -> JSON {
            self.socket.send(message: message)
            let callable: AckCallable = AckCallable.init(event: self.event, socket: self.socket)
            callable.listen(callback: {(result: JSON?) -> Void in
                self.response = result!
                self.semaphor.signal()
            })
                        
            _ = semaphor.wait(timeout: .now() + 10.0)
            return self.response!
        }
    }
    
    
    private class AckCallable : MessageObserver {
        private let event: String
        private let socket: EchoSocket
        
        private var callback: ((_: JSON) -> Void)?
        
        init(event: String, socket: EchoSocket) {
            self.event = event
            self.socket = socket
        }
        
        func listen(callback: @escaping (_: JSON?) -> Void) {
            self.callback = callback
            self.socket.register(observer: self)
        }
        
        func on(event: String, data: JSON?) {
            self.callback!(data!)
            self.socket.unregister(observer: self)
        }
    }
}

private extension EchoSocket {
    struct Observer {
        weak var observer: MessageObserver?
    }
}
