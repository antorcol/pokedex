//
//  PulseLabel.swift
//  pokedex
//
//  An extension to PaddingLabel
//
//  Created by Anthony Torrero Collins on 3/21/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit

// This extension enables a pulsing animation to the Pokemon title during 
//  stats load. Basically this is another time delay hack -- show something
//  to the user to detract from the fact that the retrieval is taking a while.
extension UILabel {
    public func pulseOn(message: String) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSNumber(float: 0.9)
        animation.duration = 0.5
        animation.repeatCount = 10.0
        animation.autoreverses = true
        self.text = message
        self.layer.addAnimation(animation, forKey: "pulse")
    }
    
    public func pulseOff(message: String) {
        self.layer.removeAnimationForKey("pulse")
        self.text = message
    }
}