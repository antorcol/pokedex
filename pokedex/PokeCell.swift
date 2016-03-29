//
//  PokeCell.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 2/29/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    
    //MARK: IBOutlets and vars
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lblLoading: UILabel!
    
    var pokemon: Pokemon!
    
    //MARK: Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 0.75
        self.layer.borderColor = UIColor(colorLiteralRed: 59/255, green: 59/255, blue: 59/255, alpha: 1.0).CGColor
        self.layer.backgroundColor = UIColor(colorLiteralRed: 59/255, green: 59/255, blue: 59/255, alpha: 0.2).CGColor
        
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    //MARK: Utility
    func configureCell(pokemon: Pokemon, isInCache:Bool = false) {
        self.pokemon = pokemon
        nameLabel.text = self.pokemon.name.capitalizedString
        thumbImg.image = UIImage(named: "\(self.pokemon.csvRowId)")
        if isInCache {
            self.layer.backgroundColor = UIColor(colorLiteralRed: 59/255, green: 59/255, blue: 59/255, alpha: 0.6).CGColor
        } else {
            self.layer.backgroundColor = UIColor(colorLiteralRed: 59/255, green: 59/255, blue: 59/255, alpha: 0.2).CGColor            
        }
    }
    
    
}
