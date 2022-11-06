//
//  Call.swift
//  CallUI
//
//  Created by Mark Boleigha on 21/05/2022.
//  Copyright © 2022 Code HK. All rights reserved.
//

import Foundation
import CallKit

struct Call: Codable {
    var id: String
    var status: CallStatus
//    var endReason: CXCallEndedReason
}

enum CallStatus: Codable {
    case ended, onHold, inProgress
}
//
//extension CXCallEndedReason: Codable {
//    public mutating func encode(to encoder: Encoder) throws {
//        let code = encoder.singleValueContainer()
//        self = try code.encode(<#T##value: Int##Int#>)
//    }
//    
//}
