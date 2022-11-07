//
//  CallAudio.swift
//  CallUI
//
//  Created by Mark Boleigha on 06/11/2022.
//  Copyright © 2022 Code HK. All rights reserved.
//

import Foundation
import AVFoundation

class CallAudio {
    var session: AVAudioSession!
    var active: Bool = false
    var micGranted = false
    
    init(){
        session = AVAudioSession.sharedInstance()
        session.requestRecordPermission { granted in
            self.micGranted = granted
            if granted {
                
                do {
                    try self.session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.videoChat, policy: AVAudioSession.RouteSharingPolicy.default, options: [.duckOthers, .allowBluetooth])
//                    self.session.setCategory(, mode: , policy: AVAudioSession.RouteSharingPolicy.default, options: )
//                    self.session.setCategory(.playAndRecord)
//                    try self.session.setCategory(.playback, mode: .voiceChat, options: [.duckOthers])
                    try self.session.setActive(true)
                }
                catch {
                    print("Couldn't set Audio session category \(error)")
                }
            } else {
                print("Couldn't set Audio session category, microphone permission denied")
            }
            
        }
    }
    
    func start() {
        guard self.micGranted == true else { return }
        do {
            try session.setPreferredSampleRate(44100.0)
            try session.setPreferredIOBufferDuration(0.005)
        } catch {
            print("error setting audio: \(error)")
        }
        
    }
    
    func pause() {
        
    }
    
    func stop() {
        try! self.session.setActive(false)
    }
}
