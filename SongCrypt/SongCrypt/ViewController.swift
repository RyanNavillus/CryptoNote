//
//  ViewController.swift
//  SongCrypt
//
//  Created by Ryan Sullivan on 1/20/17.
//  Copyright © 2017 Ryan Sullivan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var playPause: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        var songEncoder = SongEncoder()
        songEncoder.togglePlayback()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func togglePlayPause(_ sender: UIButton) {
        
    }
}

