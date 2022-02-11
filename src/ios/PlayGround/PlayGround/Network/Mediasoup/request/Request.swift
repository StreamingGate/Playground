//
//  Request.swift
//  mediasoup-ios-cient-sample
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

import Foundation
import SwiftyJSON

final internal class Request : NSObject {
    internal static let REQUEST_TIMEOUT_MS: NSInteger = 3000;
    
    internal static let shared = Request.init();
    
    private override init() {}
    
    // Send getRoomRtpCapabilitiesRequest
    func sendGetRoomRtpCapabilitiesRequest(socket: EchoSocket, roomId: String) -> JSON? {
        print("REQ) getRouterRtpCapabilities")
        return Request.shared.sendSocketAckRequest(socket: socket, data: ["request" : true, "id": 123, "method": "getRouterRtpCapabilities",  "data": []] as [String : Any])
    }
    
    func connectConsume(socket: EchoSocket, dtlsParameters: String) -> JSON? {
        return Request.shared.sendSocketAckRequest(socket: socket, data: ["request" : true, "id": 6123, "method": "connectConsume",  "data": ["dtlsParameters": dtlsParameters]] as [String : Any])
    }
    
    func consumerResume(socket: EchoSocket) {
        Request.shared.sendSocketWithoutReponse(socket: socket, message: ["request" : true, "id": 7713, "method": "consumerResume",  "data": []] as [String : Any])
    }
    
    func sendLoginRoomRequest(socket: EchoSocket, roomId: String, device: Device) -> JSON? {
        print("REQ) send login room request")
        let data: [String: Any] = ["request" : true, "id": 333, "method": "join", "data": ["displayName": "testUser", "device":  ["flag":"safari","name":"Safari","version":"14.1.2"], "roomId": roomId, "rtpCapabilities": device.getRtpCapabilities(), "sctpCapabilities": device.getSctpCapabilities()]]
        return Request.shared.sendSocketAckRequest(socket: socket, data: data)
    }
    
    func sendCreateWebRtcTransportRequest(socket: EchoSocket, roomId: String, direction: String, device: Device) -> JSON? {
        print("REQ) createWebRtcTransport")
        if direction == "audio" {
            let data: [String: Any] = ["request" : true, "id": 223, "method": "createAudioWebRtcTransport", "data": []]
            return Request.shared.sendSocketAckRequest(socket: socket, data: data)
        } else {
            let data: [String: Any] = ["request" : true, "id": 222, "method": "createWebRtcTransport", "data": []]
            return Request.shared.sendSocketAckRequest(socket: socket, data: data)
        }
        
    }

    
    func consume(socket: EchoSocket, rtp: String) -> JSON? {
        print("REQ) consume")
        let data: [String: Any] = ["request" : true, "id": 666, "method": "consume", "data" : ["rtpCapabilities": rtp]]
        return Request.shared.sendSocketAckRequest(socket: socket, data: data)
    }

    
    func sendConnectWebRtcTransportRequest(socket: EchoSocket, transportId: String, dtlsParameters: String) -> JSON? {
        print("REQ) connectWebRtcTransport")
        let data: [String: Any] = ["request" : true, "id": 55, "method": "connectWebRtcTransport", "data": ["transportId": transportId, "dtlsParameters": dtlsParameters]]
        return Request.shared.sendSocketAckRequest(socket: socket, data: data)
    }
    
    func sendResumeConsumerRequest(socket: EchoSocket, roomId: String, consumerId: String) {
        let message = ["notification" : true, "method": "resumeConsumer",  "data": ["peerId": "aj4mu8bs"]] as [String : Any]
        Request.shared.sendSocketAckRequest(socket: socket, data: message)
    }
    
    private func sendSocketAckRequest(socket: EchoSocket, data: [String: Any]) -> JSON? {
        print("socket ack request: \(data)\n")
        let semaphore: DispatchSemaphore = DispatchSemaphore.init(value: 0)
        var response: JSON?
        let queue: DispatchQueue = DispatchQueue.global()
        queue.async {
            socket.sendWithAck(message: data, completionHandler: {(res: JSON) in
                response = res
                semaphore.signal()
            })
        }
        
        _ = semaphore.wait(timeout: .now() + 10.0)
        return response

    }
    
    private func sendSocketWithoutReponse(socket: EchoSocket, message: [String: Any]) {
        print("socket ack request: \(message)\n")
        do {
            let data = try JSONSerialization.data(withJSONObject: message)
            if let dataString = String(data: data, encoding: .utf8){
                socket.send(message: dataString)
            }
        } catch {
            print("JSON serialization failed: ", error)
        }
    }
}
