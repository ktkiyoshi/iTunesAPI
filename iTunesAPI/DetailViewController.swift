//
//  DetailViewController.swift
//  iTunesAPI
//
//  Created by Kodama Takahiro on 2015/12/15.
//  Copyright © 2015年 Kiyoshi. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class DetailViewController: AVPlayerViewController {

    var previewUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let previewUrl = previewUrl {
            player = AVPlayer(URL: NSURL(string: previewUrl)!)
            player?.play()
        }
    }

}
