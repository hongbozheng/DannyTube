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
    var player:AVPlayer?
//    var videoUrl:String {
//        didSet{
//           
//        }
//    }
    override var frame: CGRect{
        didSet{
             playerLayer?.frame = frame
            controlsContainerView.frame = frame
        }
    }
    
    lazy var indicator:UIActivityIndicatorView = {
       let tmp = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        tmp.translatesAutoresizingMaskIntoConstraints = false
        tmp.startAnimating()
        return tmp
    }()
    
    lazy var pausePlayBtn:UIButton = {
        let button = UIButton(type:UIButtonType.system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(handlePausePlay), for: .touchUpInside)
        return button
    }()
    var isPlaying = false
    func handlePausePlay(){
        if isPlaying {
            player?.pause()
            pausePlayBtn.setImage(UIImage(named:"play"), for: .normal)
        }else {
            player?.play()
            pausePlayBtn.setImage(UIImage(named:"pause"), for: .normal)
        }
        isPlaying = !isPlaying
    }
    lazy var controlsContainerView:UIView = {
        let tmp = UIView()
        tmp.backgroundColor = UIColor(white: 0, alpha: 1)
        return tmp
    }()
    
    let videoLengthLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel:UILabel = {
     let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "00:00"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 13)
        return label
    }()
    lazy var videoSlider:UISlider = {
     let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named:"thumb"), for: .normal)
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    func handleSliderChange(){
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value)*totalSeconds
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                
            })
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        setupGradientLayer()
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(indicator)
        indicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        indicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayBtn)
        pausePlayBtn.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayBtn.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupPlayerView() {
        backgroundColor = .black
        let urlString = "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        if let url = URL(string: urlString){
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer!)
            playerLayer?.frame = frame
            player?.play()
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        }
    }
    
    private func setupGradientLayer(){
       let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.red.cgColor]
        gradientLayer.locations = [0.7,1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            indicator.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayBtn.isHidden = false
        }
    }
}

class VideoLauncher: NSObject {
    let HDRate:CGFloat = 9/16
    
   lazy var viewLauncher:UIView = {
    let tmp = UIView()
     tmp.backgroundColor = UIColor.white
    return tmp
    }()
    
    lazy var videoPlayerView:VideoPlayerView = {
        let tmp = VideoPlayerView()
        return tmp
    }()
    
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
                self.videoPlayerView.frame = CGRect(x: 0, y: 0, width: 150, height: 150*self.HDRate)
                self.viewLauncher
                    .frame = CGRect(x: window.frame.width - 150, y: window.frame.height - 150*self.HDRate, width: 150, height: 150*self.HDRate)

                }else{
                
                    self.viewLauncher.frame = window.frame
                    self.videoPlayerView.frame  = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.width*self.HDRate)
                }
            }, completion:nil)
            sender.isSelected = !sender.isSelected
        }
    }
    
    func showVideoPlayerWithUrl(url:String)  {
    print("play video")
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(viewLauncher)
            viewLauncher.frame = CGRect(x: window.frame.width - 10, y: window.frame.height - 10, width: 10, height: 10)
             videoPlayerView.frame = CGRect(x: 0, y: 0, width: window.frame.width, height: window.frame.width*HDRate)
//           videoPlayerView.videoUrl = url
            viewLauncher.addSubview(videoPlayerView)
             viewLauncher.addSubview(beSmallBtn)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                self.viewLauncher
                    .frame = window.frame
            }, completion: {(completion:Bool) in
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
        }
    }
}
