//
//  PokeTitleLabel.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/7/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation

// The PokeTitleLabel is the pokemon caption on the 
//  MainVC.
class PokeTitleLabel : PokeDataLabelTitle {
    override func layoutSubviews() {
        super.layoutSubviews()

        self.textAlignment = .Center
    }
}