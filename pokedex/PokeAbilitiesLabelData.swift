//
//  PokeLabel.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/6/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation
import UIKit

// Label for abilities. Using separate class just in case it needs a tweak later
class PokeAbilitiesLabelData: PokeDataLabelData {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.preferredMaxLayoutWidth = self.frame.width
    }
}