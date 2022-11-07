//
//  CallUI.swift
//  CallUI
//
//  Created by Mark Boleigha on 06/11/2022.
//  Copyright © 2022 Code HK. All rights reserved.
//

import Foundation
import PushKit
import CallKit

typealias CallUI = () -> VoIPCallService

protocol VoIPCallServiceDelegate {
//    func broadcast(event: CallEvent, call: Call)
//    func receive(intent: CallIntent, call: UUID)
}

class VoIPCallService: NSObject {
    
    private static var instance: VoIPCallService?
    
    private(set) var provider:  CXProvider?
    var appName: String? = "VoIPCallService"
    
    var delegate: VoIPCallServiceDelegate?
    var audio: CallAudio?
    
//    private var flutterIntent: FlutterMethodChannel? = nil
//    private var eventChannel: FlutterEventChannel? = nil
//
//    private var eventHandler: CallEventHandler?
    private var manager: CallManager?
    private let deviceVoIPToken = "deviceVoIPToken"
    
    
    class var shared: VoIPCallService {
        if instance == nil {
            instance = VoIPCallService()
            instance?.delegate = instance
        }
        return instance!
    }
    
    enum CallAction: String {
        case start, end, hold
    }
    
    override init() {
        super.init()
        setupCallKit()
    }
    
    func reportIncoming(call: Call) {
        var handle: CXHandle?
        handle = CXHandle(type: .generic, value: call.callerId)
        
        let callUpdate = CXCallUpdate()
        callUpdate.remoteHandle = handle
        callUpdate.supportsDTMF = false
        callUpdate.supportsHolding = true
        callUpdate.supportsGrouping = false
        callUpdate.supportsUngrouping = false
        callUpdate.hasVideo = call.isVideo!
        callUpdate.localizedCallerName = call.callerId
        
        self.provider?.reportNewIncomingCall(with: UUID(uuidString: call.uuid)!, update: callUpdate, completion: { error in
            if error == nil {
                self.configureAudio()
                self.manager?.addCall(call)
            }
        })
    }
    
    private func setupCallKit() {
        if self.provider == nil {
            let config: CXProviderConfiguration!
            if #available(iOS 14.0, *) {
                config = CXProviderConfiguration()
            } else {
                config = CXProviderConfiguration(localizedName: appName!)
            }
            config.supportsVideo = true
            config.maximumCallGroups = 1
            config.includesCallsInRecents = true
            config.maximumCallsPerCallGroup = 2
            config.supportedHandleTypes = [.phoneNumber, .emailAddress, .generic]
            
            self.provider = CXProvider(configuration: config)
            self.provider?.setDelegate(self, queue: .main)
        }
        if manager == nil {
            VoIPCallService.shared.manager = CallManager()
        }
        self.manager?.setProvider(self.provider!)
    }
    
    func configureAudio() {
        if self.audio == nil {
            self.audio = CallAudio()
        }
        audio?.start()
    }
    
    @objc public func getDevicePushTokenVoIP() -> String {
        return UserDefaults.standard.string(forKey: deviceVoIPToken) ?? ""
    }
    
}

extension VoIPCallService: VoIPCallServiceDelegate {
   
}

extension VoIPCallService: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        if(self.manager == nil){ return }
        self.manager?.removeAllCalls()
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
//        let = call = provider.deviceVoIPToken
//        self.sendEvent(.answered, )
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
//        audio?.stop()
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        action.fulfill()
    }
}

extension VoIPCallService: PKPushRegistryDelegate {
    
    // Handle updated push credentials
    func pushRegistry(_ registry: PKPushRegistry, didUpdate credentials: PKPushCredentials, for type: PKPushType) {
        let deviceToken = credentials.token.map { String(format: "%02x", $0) }.joined()
        print("device voip token: \(deviceToken)")
        //Save deviceToken to your server
        UserDefaults.standard.set(deviceToken, forKey: deviceVoIPToken)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("didInvalidatePushTokenFor")
        UserDefaults.standard.removeObject(forKey: deviceVoIPToken)
    }
    
    // Handle incoming pushes
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        
        
        

//        guard type == PKPushType.voIP else { return }
//        
//        if let call = try? payload.dictionaryPayload.customCodableObject(type: Call.self) {
//            self.reportIncoming(call: call)
//        } else {
//            let data = ["uuid" : UUID().uuidString, "handle" : "unknown"]
//            let call = try! JSONDecoder().decode(Call.self, from: data.jsonData!)
//            self.reportIncoming(call: call)
//        }
    }
}
