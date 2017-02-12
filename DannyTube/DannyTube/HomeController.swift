//
//  ViewController.swift
//  DannyTube
//
//  Created by hongbozheng on 2/8/17.
//  Copyright © 2017 fiu. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController {

    lazy var playBtn:UIButton = {
        let tmpBtn = UIButton()
        tmpBtn.setTitle("Play", for: .normal)
        tmpBtn.addTarget(self, action: #selector(playVideo), for: .touchUpInside)
        tmpBtn.setTitleColor(UIColor.red, for: .normal)
//        tmpBtn.backgroundColor = UIColor.blue
        tmpBtn.layer.borderColor = UIColor.red.cgColor
        tmpBtn.layer.borderWidth = 0.5
        tmpBtn.layer.cornerRadius = 5
        tmpBtn.clipsToBounds = true
        tmpBtn.translatesAutoresizingMaskIntoConstraints = false
        return tmpBtn
    }()
    lazy var videoPlayer:VideoLauncher = {
        let tmpVp = VideoLauncher()
        return tmpVp
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Home"
        collectionView?.backgroundColor = UIColor.white
        view.addSubview(playBtn)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(150)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":playBtn]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":playBtn]))
        view.addConstraint(NSLayoutConstraint(item: playBtn, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: playBtn, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
        
    }
    func playVideo() {
        videoPlayer.showVideoPlayer()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

