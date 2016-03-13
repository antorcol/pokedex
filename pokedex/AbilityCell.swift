//
//  PokeCellCollectionViewCell.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 2/29/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit

class AbilityCell: UITableViewCell {
    
    
    //MARK: IBOutlets and vars
    @IBOutlet weak var abilityLabel: UILabel!
    
    var pokemon: Pokemon!
    
    //MARK: Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    //MARK: Utility
    func configureCell(ability: String) {
        abilityLabel.text = ability.capitalizedString
    }
}
