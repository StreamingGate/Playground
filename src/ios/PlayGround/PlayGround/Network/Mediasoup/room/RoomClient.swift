//
//  RoomClient.swift
//  mediasoup-ios-cient-sample
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

public enum RoomError : Error {
    case DEVICE_NOT_LOADED
    case SEND_TRANSPORT_NOT_CREATED
    case RECV_TRANSPORT_NOT_CREATED
    case DEVICE_CANNOT_PRODUCE_VIDEO
    case DEVICE_CANNOT_PRODUCE_AUDIO
    case PRODUCER_NOT_FOUND
    case CONSUMER_NOT_FOUND
}

var produceId = ""

final internal class RoomClient : NSObject {
    private static let STATS_INTERVAL_MS: NSInteger = 3000
    
    private let socket: EchoSocket
    private let roomId: String
    private var producers: [String : Producer]
    private var consumers: [String : Consumer]
    private var consumersInfo: [JSON]
    private let device: Device
    
    private var joined: Bool
    private var sendTransport: SendTransport?
    private var recvTransport: RecvTransport?
    
    private var recvTransportHandler: RecvTransportHandler?
    private var producerHandler: ProducerHandler?
    private var consumerHandler: ConsumerHandler?
    
    private var roomListener: RoomListener?
    
    var dtls: String?
    
    public init(socket: EchoSocket, device: Device, roomId: String, roomListener: RoomListener) {
        self.socket = socket
        self.device = device
        self.roomId = roomId
        self.roomListener = roomListener
        
        self.producers = [String : Producer]()
        self.consumers = [String : Consumer]()
        self.consumersInfo = [JSON]()
        self.joined = false
        
        super.init()
    }
    
    func join() throws {
        // Check if the device is loaded
        if !self.device.isLoaded() {
            throw RoomError.DEVICE_NOT_LOADED
        }
        
        // if the user is already joined do nothing
        if self.joined {
            return
        }
        
        _ = Request.shared.sendLoginRoomRequest(socket: self.socket, roomId: self.roomId, device: self.device)
        self.joined = true
        print("join() join success")
    }
    
    func createSendTransport() {
        // Do nothing if send transport is already created
        if (self.sendTransport != nil) {
            print("createSendTransport() send transport is already created...")
            return
        }
        
        self.createWebRtcTransport(direction: "send")
        print("createSendTransport() send transport created")
    }
    
    func createRecvTransport() {
        // Do nothing if recv transport is already created
        if (self.recvTransport != nil) {
            print("createRecvTransport() recv transport is already created...")
            return
        }
        
        self.createWebRtcTransport(direction: "recv")
        print("createRecvTransport() recv transport created")
    }
    
    func consumeTrack(consumerInfo: JSON) {
        if (self.recvTransport == nil) {
            // User has not yet created a transport for receiving so temporarily store it
            // and play it when the recv transport is created
            self.consumersInfo.append(consumerInfo)
            return
        }
        
        let kind: String = consumerInfo["kind"].stringValue
        
        // if already consuming type of track remove it, TODO support multiple remotes?
        for consumer in self.consumers.values {
            if consumer.getKind() == kind {
                print("consumeTrack() removing consumer kind=" + kind)
                self.consumers.removeValue(forKey: consumer.getId())
            }
        }
        
        let id: String = consumerInfo["id"].stringValue
        let producerId: String = consumerInfo["producerId"].stringValue
        if producerId == "" {
            print("Producer 없음")
            return
        }
        let rtpParameters: JSON = consumerInfo["rtpParameters"]
        print("consumeTrack() rtpParameters " + rtpParameters.description)
        
        self.consumerHandler = ConsumerHandler.init()
        self.consumerHandler!.delegate = self.consumerHandler

        let kindConsumer: Consumer = self.recvTransport!.consume(self.consumerHandler!.delegate!, id: id, producerId: producerId, kind: kind, rtpParameters: rtpParameters.description)
        self.consumers[kindConsumer.getId()] = kindConsumer
            
        print("consumeTrack() consuming id =" + kindConsumer.getId())
            
        self.roomListener?.onNewConsumer(consumer: kindConsumer)
    }
    
    func resumeRemoteVideo() throws {
        print("~~~produceId : \(produceId)")
    }
    
    func resumeRemoteAudio() throws {
        let consumer: Consumer = try self.getConsumerByKind(kind: "audio")
        Request.shared.sendResumeConsumerRequest(socket: self.socket, roomId: self.roomId, consumerId: consumer.getId())
    }
    
    private func createWebRtcTransport(direction: String) {
        
        let response = Request.shared.sendCreateWebRtcTransportRequest(socket: self.socket, roomId: "test", direction: direction, device: device)
        
        print("createWebRtcTransport() response = " + (response?["data"].description ?? "없음5"))
        
        guard let webRtcTransportData: JSON = response?["data"] else { return }
        
        let id: String = webRtcTransportData["id"].stringValue
        let iceParameters: JSON = webRtcTransportData["iceParameters"]
        let iceCandidatesArray: JSON = webRtcTransportData["iceCandidates"]
        let dtlsParameters: JSON = webRtcTransportData["dtlsParameters"]
        self.dtls = dtlsParameters.description

        switch direction {
        case "recv":
            self.recvTransportHandler = RecvTransportHandler.init(parent: self)
            self.recvTransportHandler!.delegate = self.recvTransportHandler!
            self.recvTransport = self.device.createRecvTransport(self.recvTransportHandler!.delegate!, id: id, iceParameters: iceParameters.description, iceCandidates: iceCandidatesArray.description, dtlsParameters: dtlsParameters.description)

            let result = Request.shared.consume(socket: self.socket, rtp: device.getRtpCapabilities()!)
            guard let consumeData = result?["data"] else { return }
//            produceId = consumeData["producerId"] as! String
            self.consumeTrack(consumerInfo: consumeData)

            let result3 = Request.shared.consumerResume(socket: self.socket)
            break
        default:
            print("createWebRtcTransport() invalid direction " + direction)
        }
    }
    
    private func handleLocalTransportConnectEvent(transport: Transport, dtlsParameters: String) {
        print("handleLocalTransportConnectEvent() id =" + transport.getId())
        let result2 = Request.shared.connectConsume(socket: self.socket, dtlsParameters: dtlsParameters)
    }
    
    private func getProducerByKind(kind: String) throws -> Producer {
        for producer in self.producers.values {
            if producer.getKind() == kind {
                return producer
            }
        }
        
        throw RoomError.PRODUCER_NOT_FOUND
    }
    
    private func getConsumerByKind(kind: String) throws -> Consumer {
        for consumer in self.consumers.values {
            if consumer.getKind() == kind {
                return consumer
            }
        }
        
        throw RoomError.CONSUMER_NOT_FOUND
    }
    
    // Class to handle recv transport listener events
    private class RecvTransportHandler : NSObject, RecvTransportListener {
        fileprivate weak var delegate: RecvTransportListener?
        private var parent: RoomClient
        
        init(parent: RoomClient) {
            self.parent = parent
        }
        
        func onConnect(_ transport: Transport!, dtlsParameters: String!) {
            print("RecvTransport::onConnect")
            self.parent.handleLocalTransportConnectEvent(transport: transport, dtlsParameters: dtlsParameters)
        }
        
        func onConnectionStateChange(_ transport: Transport!, connectionState: String!) {
            print("RecvTransport::onConnectionStateChange newState = " + connectionState)
        }
    }
    
    // Class to handle producer listener events
    private class ProducerHandler : NSObject, ProducerListener {
        fileprivate weak var delegate: ProducerListener?
        
        func onTransportClose(_ producer: Producer!) {
            print("Producer::onTransportClose")
        }
    }
    
    // Class to handle consumer listener events
    private class ConsumerHandler : NSObject, ConsumerListener {
        fileprivate weak var delegate: ConsumerListener?
        
        func onTransportClose(_ consumer: Consumer!) {
            print("Consumer::onTransportClose")
        }
    }
}
