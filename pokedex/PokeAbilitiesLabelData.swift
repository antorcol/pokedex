//
//  PokeLabel.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/6/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation
import UIKit

/* using separate class just in case it needs a tweak later */
class PokeAbilitiesLabelData: PokeDataLabelData {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        let fontSize = CGFloat(14.0)
//        self.font = UIFont(name: "HelveticaNeue", size: fontSize)
//        self.textColor = UIColor(colorLiteralRed: 59/255, green: 59/255, blue: 59/255, alpha: 1.0)
        self.preferredMaxLayoutWidth = self.frame.width
//        self.textAlignment = .Left
    }
}