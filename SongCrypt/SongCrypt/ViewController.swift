//
//  ViewController.swift
//  SongCrypt
//
//  Created by Ryan Sullivan on 1/20/17.
//  Copyright © 2017 Ryan Sullivan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var FlangerButton: UIButton!
    @IBOutlet weak var EchoButton: UIButton!
    @IBOutlet weak var ReverbButton: UIButton!
    @IBOutlet weak var RollButton: UIButton!
    @IBOutlet weak var unlockButton: UIButton!
    var repeatingTimer:Timer!
    var totalTime = 0.0
    var songEncoder:SongEncoder!
    var encodedKey = [Int]()
    var fxEnabled = [false, false, false, false] //0 Flanger, 1 = Echo, 2 = Reverb, 3 = Roll


    override func viewDidLoad() {
        super.viewDidLoad()
        songEncoder = SongEncoder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func unlock(_ sender: UIButton) {
        songEncoder.togglePlayback()
        startEncoding()
    }
    @IBAction func Flanger(_ sender: UIButton) {
        songEncoder.toggleFx(index: 5)
        fxEnabled[0] ? (fxEnabled[0] = false) : (fxEnabled[0] = true)
    }
    @IBAction func Echo(_ sender: UIButton) {
        songEncoder.toggleFx(index: 4)
        fxEnabled[1] ? (fxEnabled[1] = false) : (fxEnabled[1] = true)

    }
    @IBAction func Reverb(_ sender: UIButton) {
        songEncoder.toggleFx(index: 7)
        fxEnabled[2] ? (fxEnabled[2] = false) : (fxEnabled[2] = true)

    }
    @IBAction func Roll(_ sender: UIButton) {
        songEncoder.toggleFx(index: 2)
        fxEnabled[3] ? (fxEnabled[3] = false) : (fxEnabled[3] = true)
    }
    
    func startEncoding()
    {
            self.unlockButton.isEnabled = false
            self.repeatingTimer  = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.encodeEffects), userInfo: nil, repeats: true)
    }
    
    func encodeEffects(timer:Timer) {
        var digit:UInt8 = 0b00000000
        for enabled in fxEnabled{
            digit = digit << 1
            if enabled
            {
                digit = digit | 1
            }
            let str = String(digit, radix: 2)
            print("Binary: \(str)")
        }
        encodedKey.append(Int(digit))
        totalTime += timer.timeInterval
        if totalTime == 10
        {
            timer.invalidate()
            songEncoder.togglePlayback()
            checkKey()
            totalTime = 0
            songEncoder.seekTo(percent: 0)
            self.unlockButton.isEnabled = true
        }
    }
    
    func checkKey()
    {
        
    }
    
}

