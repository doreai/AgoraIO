//
//  ViewController.swift
//  SegmentExample
//
//  Created by Sam on 30/07/21.
//

import UIKit
import AVFoundation
import AgoraRtcKit
import DoreSegment


class ViewController: UIViewController, AgoraRtcEngineDelegate, AgoraMediaFilterEventDelegate {
    
    func onEvent(_ vendor: String?, extension: String?, key: String?, json_value: String?) {
        
    }
    
    
    public var agoraKit : AgoraRtcEngineKit?
    
    @IBOutlet weak var mView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func setupLocalVideo() {
        // Enables the video module
        let cfg:AgoraRtcEngineConfig = AgoraRtcEngineConfig()
        let apikey:String = "xxxxxx" //insert agora api key here
        cfg.appId = apikey
        cfg.eventDelegate = self
        agoraKit = AgoraRtcEngineKit.sharedEngine(with: cfg, delegate: self)
        //enable extension
        agoraKit!.enableExtension(withVendor: "DoreAI", extension: "DoreSegment", enabled: true)
        agoraKit!.setChannelProfile(AgoraChannelProfile.liveBroadcasting)
        agoraKit!.setClientRole(AgoraClientRole.broadcaster)
        //agoraKit.enableVideo()
        let videoCanvas = AgoraRtcVideoCanvas()
        videoCanvas.uid = 0
        videoCanvas.renderMode = .hidden
        videoCanvas.view = mView
        // Sets the local video view
        agoraKit!.setupLocalVideo(videoCanvas)
        agoraKit!.enableVideo()
        agoraKit!.joinChannel(byToken: nil, channelId: "segtest", info: nil, uid: 0) { (String, UInt, Int) in
            
        }
        agoraKit!.startPreview()
        agoraKit!.setEnableSpeakerphone(true)
        UIApplication.shared.isIdleTimerDisabled = true;
        let vConfig = AgoraVideoEncoderConfiguration.init(size: AgoraVideoDimension480x360, frameRate: .fps24, bitrate: AgoraVideoBitrateStandard, orientationMode: .fixedPortrait, mirrorMode : .auto )
        agoraKit!.setVideoEncoderConfiguration(vConfig)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupLocalVideo()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
    }
    
    @IBAction func btnBackground2(_ sender: Any) {
        
        let stringPath = Bundle.main.path(forResource: "bg2", ofType: "png")
        let bgImage:UIImage = UIImage(contentsOfFile: stringPath!)!
        let base64Txt:String = (bgImage.pngData()?.base64EncodedString())!
        agoraKit!.setExtensionPropertyWithVendor("DoreAI", extension: "DoreSegment", key: "bgImage", value: base64Txt)
    }
    @IBAction func btnBackground1(_ sender: Any) {
        let stringPath = Bundle.main.path(forResource: "bg1", ofType: "png")
        let bgImage:UIImage = UIImage(contentsOfFile: stringPath!)!
        let base64Txt:String = (bgImage.pngData()?.base64EncodedString())!
        agoraKit!.setExtensionPropertyWithVendor("DoreAI", extension: "DoreSegment", key: "bgImage", value: base64Txt)
    }
    
    @IBAction func btnStartSegment(_ sender: Any) {
        
        let jsonObject: NSMutableDictionary = NSMutableDictionary()
        jsonObject.setValue("xxxxx", forKey: "apiKey") //insert DoreSegment project apiKey here
        jsonObject.setValue("xxxxx", forKey: "license") //insert DoreSegment project license key here
        let jsonData: NSData
        do {
            jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: JSONSerialization.WritingOptions()) as NSData
            let jsonString = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
            agoraKit!.setExtensionPropertyWithVendor("DoreAI", extension: "DoreSegment", key: "start", value: jsonString)
            
        } catch _ {
            print ("JSON Failure")
        }
        
        
    }
    
}

