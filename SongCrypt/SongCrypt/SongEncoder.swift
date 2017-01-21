//
//  SongEncoder.swift
//  SongCrypt
//
//  Created by Ryan Sullivan on 1/20/17.
//  Copyright © 2017 Ryan Sullivan. All rights reserved.
//

let NUMFXUNITS = 8
let TIMEPITCHINDEX = 0
let PITCHSHIFTINDEX = 1
let ROLLINDEX = 2
let FILTERINDEX = 3
let EQINDEX = 4
let FLANGERINDEX = 5
let DELAYINDEX = 6
let REVERBINDEX = 7

import Foundation
class SongEncoder: NSObject {
    var superpowered:Superpowered!
    
    override init() {
        superpowered = Superpowered()
        superpowered.toggle()
        superpowered.togglePlayback()
    }
    
    func startEncoding() {
    
    
    }
    
    func togglePlayback() {
        superpowered.togglePlayback()
    }
    
    func toggle() {
        superpowered.toggle()
    }
    
    func toggleFx(index:Int) {
        superpowered.toggleFx(Int32(index))
    }
    
    func seekTo(percent:Float){
        superpowered.seek(to: percent)
    }
}
