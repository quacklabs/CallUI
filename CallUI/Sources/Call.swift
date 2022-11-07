//
//  Call.swift
//  CallUI
//
//  Created by Mark Boleigha on 21/05/2022.
//  Copyright © 2022 Code HK. All rights reserved.
//

import Foundation
import CallKit

enum CallAction: String {
    case answerCall, activeCalls, getDeviceVoIPToken, startCall, endCall
}

struct Call: Codable {
    var uuid: String
    private(set) var status: CallStatus
    var isVideo: Bool? = false
    var callerId: String
    var remoteToken: String?
    var outgoing: Bool? = false
    var createdAt: String
    var endedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case uuid, isVideo, callerId, remoteToken, createdAt, outgoing, endedAt, status
    }

    init(from decoder: Decoder) throws {
        let values = try! decoder.container(keyedBy: CodingKeys.self)
        
        uuid = try values.decode(String.self, forKey: .uuid)
        isVideo = try values.decode(Bool.self, forKey: .isVideo)
        callerId = try values.decode(String.self, forKey: .callerId)
        endedAt = try values.decode(String.self, forKey: .endedAt)
        remoteToken = try values.decodeIfPresent(String.self, forKey: .remoteToken)
        createdAt = try values.decode(String.self, forKey: .createdAt)
        outgoing = try values.decode(Bool.self, forKey: .outgoing)
        status = try values.decode(CallStatus.self, forKey: .status)
    }
    
//    func encode(to encoder: Encoder) throws {
//        do {
//            let container = try encoder.container(keyedBy: CodingKeys.self)
//        } catch error {
//            //print me
//        }
//
//        try container.encode(uuid, forKey: .uuid)
//        try container.encode(isVideo, forKey: .isVideo)
//        try container.encodeIfPresent(callerId, forKey: .callerId)
//        try container.encodeIfPresent(remoteToken, forKey: .remoteToken)
//        try container.encode(createdAt, forKey: .createdAt)
//    }
    
    func update(_ status: CallStatus) {
        
    }
    
}

enum CallStatus: Codable {
    case ended, onHold, inProgress
}
//
//extension CXCallEndedReason: Codable {
//    public mutating func encode(to encoder: Encoder) throws {
//        let code = encoder.singleValueContainer()
//        self = try code.encode(value: Int)
//    }
//    
//}
