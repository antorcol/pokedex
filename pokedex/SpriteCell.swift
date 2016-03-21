//
//  SpriteCell.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/14/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit

class SpriteCell: UICollectionViewCell {
    
    
    //MARK: IBOutlets and vars
    @IBOutlet weak var lblSpriteUrl: UILabel!
    @IBOutlet weak var imgSprite: UIImageView!
    
    var pokemon: Pokemon!
    
    //MARK: Init
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    //MARK: Utility
    func configureCell(name: String, spriteUrlStr: String) {
        lblSpriteUrl.text = name
        
        if let spriteUrl = NSURL(string: spriteUrlStr) {
            if let data = NSData(contentsOfURL: spriteUrl) {
                imgSprite.image = UIImage(data: data)
            }
        }
        
    }
}
