//
//  CallProvider.swift
//  CallUI
//
//  Created by Mark Boleigha on 21/05/2022.
//  Copyright © 2022 Code HK. All rights reserved.
//

import Foundation
import CallKit

class CallProvider: NSObject {
    
    var calls: [Call] = []
    
    override init() {
        super.init()
    }
    
    
    func call(id: UUID) -> Call? {
        return self.calls.first(where: { $0.id == id.uuidString })
    }
}

extension CallProvider: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        guard let call = self.call(id: action.callUUID) else {
            action.fail()
            return
        }
        provider.reportCall(with: action.callUUID, endedAt: Date(), reason: .remoteEnded)
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        
    }
    
    
}
