//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Lawrence Tan on 9/18/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
   
    var avPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var chipmunkBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var fastBtn: UIButton!
    @IBOutlet weak var slowBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        avPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        avPlayer.enableRate = true
        
        
    }

    @IBAction func onSlow(sender: AnyObject) {
        self.playAudioAtSpeed(0.5)
    }

    @IBAction func onFast(sender: AnyObject) {
        self.playAudioAtSpeed(1.5)
    }
    
    func playAudioAtSpeed(rate: CGFloat){
        avPlayer.stop()
        avPlayer.rate = Float(rate)
        self.stopBtn.hidden = false
        self.checkIfAudioIsPlaying()
        avPlayer.play()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    @IBAction func onChipmunk(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func onStop(sender: AnyObject) {
        self.stopBtn.hidden = true
        self.stopAllPlaybacks()
    }
    
    @IBAction func onDarkVader(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    func checkIfAudioIsPlaying () {
        if avPlayer.currentTime > 0 {
            avPlayer.currentTime = 0
        }
    }
    
    //New Function
    func playAudioWithVariablePitch(pitch: Float){
        self.stopAllPlaybacks()
        
        self.stopBtn.hidden = false
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()
    }
    
    func stopAllPlaybacks() {
        avPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
}
