//
//  SongEncoder.swift
//  SongCrypt
//
//  Created by Ryan Sullivan on 1/20/17.
//  Copyright © 2017 Ryan Sullivan. All rights reserved.
//

import Foundation
class SongEncoder: NSObject {
    var superpowered:Superpowered!
    
    override init() {
        superpowered = Superpowered()
        //superpowered.toggle()
    }
    
    func startEncoding() {
    
    
    }
    
    func togglePlayback() {
        superpowered.togglePlayback()
    }
    
    func toggle() {
        superpowered.toggle()
    }
}
