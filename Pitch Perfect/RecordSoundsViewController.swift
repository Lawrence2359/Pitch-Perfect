//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Lawrence Tan on 9/16/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var micBtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var lblMic: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        // Do any additional setup after loading the view, typically from a nib.
        self.stopBtn.hidden = true;
        self.micBtn.enabled = true;
        self.lblMic.text = "Tap to Record"
    }
    
    @IBAction func onMicButton(sender: AnyObject) {
        self.lblMic.text = "Recording..."
        self.stopBtn.hidden = false;
        self.micBtn.enabled = false;
        
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(filePath)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func onStopBtn(sender: AnyObject) {
        self.lblMic.text = "Tap to Record"
        self.stopBtn.hidden = true;
        self.micBtn.enabled = true;
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag){
            recordedAudio = RecordedAudio(withFilePath: recorder.url, andTitle: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            print("Recording Failed")
            self.lblMic.text = "Tap to Record"
            self.stopBtn.hidden = true;
            self.micBtn.enabled = true;
        }
    }
}

