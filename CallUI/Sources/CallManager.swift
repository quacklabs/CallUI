//
//  CallManager.swift
//  CallUI
//
//  Created by Mark Boleigha on 06/11/2022.
//  Copyright © 2022 Code HK. All rights reserved.
//

import Foundation
import CallKit

class CallManager: NSObject {
    private let controller = CXCallController()
    private(set) var calls = [Call]()
    private var provider: CXProvider?
    
    
    
    func setProvider(_ sharedProvider: CXProvider) {
        self.provider = sharedProvider
    }
    
    func startOutgoingCall(call: Call, completion: @escaping (Bool) -> Void) {
        guard let provider = provider else {
            return
        }
        
        let handle = CXHandle(type: .generic, value: call.callerId)
        let startCallAction = CXStartCallAction(call: UUID(uuidString: call.uuid)!, handle: handle)
        startCallAction.isVideo = call.isVideo!
//
//        let transaction = CXTransaction()
//        transaction.addAction(startCallAction)
//
//        controller.request(transaction) { error in
//            if let error = error {
//                completion(false)
//                self.removeAllCalls()
//            } else {
//                provider.reportOutgoingCall(with: UUID(uuidString: call.uuid)!, startedConnectingAt: Date())
//                self.addCall(call)
//                completion(true)
//            }
//        }
    }
    
    func endCall(call: Call) {
//        let endCallAction = CXEndCallAction(call: UUID(uuidString: call.uuid)!)
//        let callTransaction = CXTransaction()
//        callTransaction.addAction(endCallAction)
//        //requestCall
//        controller.request(callTransaction) { error in
//            if let error = error {
//                print("error: \(error.localizedDescription)")
//                self.removeAllCalls()
//            } else {
//                self.provider?.reportCall(with: UUID(uuidString: call.uuid)!, endedAt: Date(), reason: .remoteEnded)
//                self.removeCall(call)
//            }
//        }
    }
    
    func removeAllCalls() {
        calls.forEach { call in
            self.provider?.reportCall(with: UUID(uuidString: call.uuid)!, endedAt: Date(), reason: .remoteEnded)
        }
        calls.removeAll()
    }
    
    func addCall(_ call: Call){
        
        if callWithUUID(uuid: UUID(uuidString: call.uuid)!) != nil {
            return
        }
        calls.append(call)
    }
    
    func removeCall(_ call: Call) {
        if let call = callWithUUID(uuid: UUID(uuidString: call.uuid)!) {
            self.calls.removeAll(where: { $0.uuid == call.uuid })
        }
    }
    
    func activeCalls() -> [[String: Any?]] {
        let calls = controller.callObserver.calls
        var json = [[String: Any?]]()
        for call in calls {
            if let callItem = self.callWithUUID(uuid: call.uuid) {
                let item = callItem.list!
                json.append(item)
            }
        }
        return json
    }
    
    func callWithUUID(uuid: UUID) -> Call?{
        return calls.first(where: { $0.uuid == uuid.uuidString })
    }
}

extension CallManager: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        if call.hasEnded {
//            if self.activeCalls.count > 0 {
//                if let index = self.activeCalls.firstIndex(where: { $0.uuid == call.uuid  }) {
//                    self.activeCalls.remove(at: index)
//                }
//            }
        }
    }
}
