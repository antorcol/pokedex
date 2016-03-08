//
//  PokeLabel.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/6/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation
import UIKit

class PokeDataLabelData: PaddingLabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let fontSize = CGFloat(14.0)// self.font.pointSize;
        self.font = UIFont(name: "HelveticaNeue", size: fontSize)
        self.textColor = UIColor(colorLiteralRed: 59/255, green: 59/255, blue: 59/255, alpha: 1.0)
        self.preferredMaxLayoutWidth = self.frame.width
        self.textAlignment = .Left
    }
}