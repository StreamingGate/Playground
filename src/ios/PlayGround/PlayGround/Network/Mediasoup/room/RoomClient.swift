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

final internal class RoomClient : NSObject {
    private static let STATS_INTERVAL_MS: NSInteger = 3000
    
    private let socket: EchoSocket
    private let roomId: String
    private var producers: Producer
    private var consumers: Consumer
    private var audioConsumers: Consumer
    private var consumersInfo: [JSON]
    private let device: Device
    
    private var joined: Bool
    private var recvTransport: RecvTransport?
    private var audioRecvTransport: RecvTransport?
    
    private var recvTransportHandler: RecvTransportHandler?
    private var audioRecvTransportHandler: AudioRecvTransportHandler?
    private var consumerHandler: ConsumerHandler?
    
    private var audioConsumerHandler: AudioConsumerHandler?
    
    private var roomListener: RoomListener?
    
    var dtls: String?
    
    public init(socket: EchoSocket, device: Device, roomId: String, roomListener: RoomListener) {
        self.socket = socket
        self.device = device
        self.roomId = roomId
        self.roomListener = nil
        self.roomListener = roomListener
        
        self.producers = Producer()
        self.consumers = Consumer()
        self.audioConsumers = Consumer()
        self.consumersInfo = [JSON]()
        self.joined = false
        self.recvTransportHandler?.delegate = nil
        self.consumerHandler?.delegate = nil
        super.init()
    }
    
    func createRecvTransport() {
        if (self.recvTransport != nil) {
            print("createRecvTransport() recv transport is already created...")
            return
        }
        
        self.createWebRtcTransport(direction: "recv")
        print("createRecvTransport() recv transport created")
    }
    
    func consumeTrack(consumerInfo: JSON) {
        if (self.recvTransport == nil) {
            self.consumersInfo.append(consumerInfo)
            return
        }
        let kind: String = consumerInfo["kind"].stringValue
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
        self.consumers = kindConsumer
        
        print("consumeTrack() consuming id =" + kindConsumer.getId())
            
        self.roomListener?.onNewConsumer(consumer: kindConsumer)
    }
    
    func resumeRemoteVideo() throws {
    }
    
    func resumeRemoteAudio() throws {
        let consumer: Consumer = try self.getConsumerByKind(kind: "audio")
        Request.shared.sendResumeConsumerRequest(socket: self.socket, roomId: self.roomId, consumerId: consumer.getId())
    }
    
    private func createWebRtcTransport(direction: String) {
        let response = Request.shared.sendCreateWebRtcTransportRequest(socket: self.socket, roomId: "test", direction: direction, device: device)
        
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
            self.consumeTrack(consumerInfo: consumeData)
            let _ = Request.shared.consumerResume(socket: self.socket)
            break
        default:
            print("createWebRtcTransport() invalid direction " + direction)
        }
    }
    
    private func handleLocalTransportConnectEvent(transport: Transport, dtlsParameters: String) {
        print("handleLocalTransportConnectEvent() id =" + transport.getId())
        let _ = Request.shared.connectConsume(socket: self.socket, dtlsParameters: dtlsParameters)
    }
    
    private func getProducerByKind(kind: String) throws -> Producer {
        if self.producers.getKind() == kind {
            return self.producers
        }
        throw RoomError.PRODUCER_NOT_FOUND
    }
    
    private func getConsumerByKind(kind: String) throws -> Consumer {
        if self.consumers.getKind() == kind {
            return self.consumers
        }
        
        throw RoomError.CONSUMER_NOT_FOUND
    }
    
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
    
    private class AudioRecvTransportHandler : NSObject, RecvTransportListener {
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
    
    private class ConsumerHandler : NSObject, ConsumerListener {
        fileprivate weak var delegate: ConsumerListener?
        
        func onTransportClose(_ consumer: Consumer!) {
            print("Consumer::onTransportClose")
        }
    }
    
    private class AudioConsumerHandler : NSObject, ConsumerListener {
        fileprivate weak var delegate: ConsumerListener?
        
        func onTransportClose(_ consumer: Consumer!) {
            print("Consumer::onTransportClose")
        }
    }
}
