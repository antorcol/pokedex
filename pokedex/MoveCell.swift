//
//  MoveCell.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/14/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit

class MoveCell: UICollectionViewCell {
    
    
    //MARK: IBOutlets and vars
    @IBOutlet weak var moveLabel: UILabel!
    
    var pokemon: Pokemon!
    
    //MARK: Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    //MARK: Utility
    func configureCell(move: String) {
        moveLabel.text = move
        
    }
}
