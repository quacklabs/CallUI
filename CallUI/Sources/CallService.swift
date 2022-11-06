//
//  CallService.swift
//  CallUI
//
//  Created by Mark Boleigha on 21/05/2022.
//  Copyright © 2022 Code HK. All rights reserved.
//
import AVFoundation
import Foundation
import CallKit

protocol CallServiceDelegate {
    
}

class CallService {
    private static var instance: CallService?
    private let provider: CXProvider!
    var appName: String? = "CallUI"
    var queue: DispatchQueue?
    var providerHandler: CXProviderDelegate?
    var handler: CallProvider!
    
    class var shared: CallService {
        if instance == nil {
            instance = CallService()
        }
        return instance!
    }
    
    
    init(appName: String? = nil) {
        self.appName = appName ?? self.appName
        let config = CXProviderConfiguration(localizedName: self.appName!)
        config.supportsVideo = true
        config.maximumCallGroups = 1
        config.maximumCallsPerCallGroup = 5
        config.supportedHandleTypes = [.phoneNumber, .generic, .emailAddress]
        
        self.queue = DispatchQueue.main
        handler = CallProvider()
        
        self.provider = CXProvider(configuration: config)
        self.provider.setDelegate(handler, queue: self.queue)
    }
    
    func configure(withAppName: String) {
        self.appName = withAppName
        CallService.instance = CallService(appName: withAppName)
    }
    
    
    
    deinit {
        provider.invalidate()
    }
}
