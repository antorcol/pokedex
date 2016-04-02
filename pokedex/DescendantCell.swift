//
//  DescendantCell.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/24/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit

// This is the spec for the descendant collection.
class DescendantCell: UICollectionViewCell {
    
    //MARK: IBOutlets and vars    
    @IBOutlet weak var lblDescendantName: UILabel!
    @IBOutlet weak var imgDescendant: UIImageView!
    var pokemon: Pokemon!
    
    //MARK: Init    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    //MARK: Utility
    func configureCell(descendantName: String, descendantId: String) {
        lblDescendantName.text = descendantName
        imgDescendant.image = UIImage(named: descendantId)        
    }
}
