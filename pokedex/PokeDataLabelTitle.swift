//
//  PokeLabel.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/6/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation
import UIKit

class PokeDataLabelTitle: PaddingLabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let fontSize = CGFloat(14.0)
        self.font = UIFont(name: "HelveticaNeue-Bold", size: fontSize)
        self.textColor = UIColor(colorLiteralRed: 59/255, green: 59/255, blue: 59/255, alpha: 1.0)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(colorLiteralRed: 59/255, green: 59/255, blue: 59/255, alpha: 1.0).CGColor
        self.backgroundColor = UIColor(colorLiteralRed: 248/255, green: 199/255, blue: 24/255, alpha: 0.75)
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        self.preferredMaxLayoutWidth = self.frame.width
        self.textAlignment = .Right
    }
}