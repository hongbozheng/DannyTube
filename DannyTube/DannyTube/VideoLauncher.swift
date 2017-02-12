//
//  VideoLauncher.swift
//  DannyTube
//
//  Created by hongbozheng on 2/11/17.
//  Copyright © 2017 fiu. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    var playerLayer:AVPlayerLayer?
    override var frame: CGRect{
        didSet{
             playerLayer?.frame = frame
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        let urlString = "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        if let url = URL(string: urlString){
            let player = AVPlayer(url: url)
             playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer!)
            playerLayer?.frame = frame
            player.play()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject {
    let HDRate:CGFloat = 9/16
    var viewLauncher:UIView?
    var videoPlayerView:VideoPlayerView?
    lazy var beSmallBtn:UIButton = {
        let tmp = UIButton(frame:CGRect(x: 0, y: 0, width: 20, height: 20))
        tmp.setBackgroundImage(UIImage(named:"arrow-down"), for: .normal)
        tmp.setBackgroundImage(UIImage(named:"arrow-up"), for: .selected)
        tmp.addTarget(self, action: #selector(viewBeSmall), for: .touchUpInside)
        return tmp
    }()
    
     func viewBeSmall(sender:UIButton){
       
        print(sender.isSelected)
        
        if let window = UIApplication.shared.keyWindow {
            
          
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                if !sender.isSelected {
                self.videoPlayerView?.frame = CGRect(x: 0, y: 0, width: 150, height: 150*self.HDRate)
                self.viewLauncher?
                    .frame = CGRect(x: window.frame.width - 150, y: window.frame.height - 150*self.HDRate, width: 150, height: 150*self.HDRate)

                }else{
                
                    self.viewLauncher?.frame = window.frame
                    self.videoPlayerView?.frame  = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.width*self.HDRate)
                }
            }, completion:nil)
            sender.isSelected = !sender.isSelected
        }
    }
    func showVideoPlayer()  {
    print("play video")
        if let window = UIApplication.shared.keyWindow {
             viewLauncher = UIView()
            window.addSubview(viewLauncher!)
           viewLauncher?.backgroundColor = UIColor.white
            viewLauncher?.frame = CGRect(x: window.frame.width - 10, y: window.frame.height - 10, width: 10, height: 10)
             videoPlayerView = VideoPlayerView(frame:CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.width*HDRate))
            viewLauncher?.addSubview(videoPlayerView!)
             viewLauncher?.addSubview(beSmallBtn)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                self.viewLauncher?
                    .frame = window.frame
            }, completion: {(completion:Bool) in
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
        }
    }
}
