//
//  EnhancedDetailsVC.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/7/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit

class EnhancedDetailsVC: UIViewController {

    var pokemon: Pokemon!

    //MARK: Basic Stats
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblBaseDescription: UILabel!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var lblSpeciesVal: PokeDataLabelData!
    @IBOutlet weak var lblHitPointsVal: PokeDataLabelData!
    @IBOutlet weak var lblHeightVal: PokeDataLabelData!
    @IBOutlet weak var lblWeightVal: PokeDataLabelData!
    @IBOutlet weak var lblSpeedVal: PokeDataLabelData!
    @IBOutlet weak var lblAttackVal: PokeDataLabelData!
    @IBOutlet weak var lblTypeVal: PokeDataLabelData!
    @IBOutlet weak var lblDefenseVal: PokeDataLabelData!
    @IBOutlet weak var lblSpAttackVal: PokeDataLabelData!
    @IBOutlet weak var lblSpDefenseVal: PokeDataLabelData!
    
    //    @IBOutlet weak var abilitesView: UIView!
    //    @IBOutlet weak var movesView: UIView!
    //    @IBOutlet weak var spritesView: UIView!
    //    @IBOutlet weak var evoView: UIView!
    
    
    //scroller
    @IBOutlet weak var mainHScroller: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
        }
        
        statsView.hidden = false
//        abilitesView.hidden = true
//        movesView.hidden = true
//        spritesView.hidden = true
//        evoView.hidden = true
        

    }
  
    override func viewDidLayoutSubviews() {
    
        mainHScroller.contentSize = CGSizeMake(300, 1200)
    
    }

    func updateUI() {
//        self.lblName.text = self.pokemon.name.capitalizedString
        self.imgMain.image = UIImage(named: String(self.pokemon.speciesId))
        if pokemon.type != "" {
            self.lblTypeVal.text = pokemon.type
        }
        if self.pokemon.height > 0 {
            self.lblHeightVal.text = String(self.pokemon.height)
        } else {
            self.lblHeightVal.text = "Unknown"
        }
        if self.pokemon.weight > 0 {
            self.lblWeightVal.text = String(self.pokemon.weight)
        } else {
            self.lblWeightVal.text = "Unknown"
        }
        if String(self.pokemon.attack) != "" {
            self.lblAttackVal.text = String(self.pokemon.attack)
        }
        
       // if String(self.pokemon.speciesId) != "" {
       //     self.lblPokeId.text = String(self.pokemon.speciesId)
       // }
        if String(self.pokemon.defense) != "" {
            self.lblDefenseVal.text = String(self.pokemon.defense)
        }
        if self.pokemon.description != "" {
            self.lblBaseDescription.text = self.pokemon.description
        }
    }

    @IBAction func sgCategories_Pressed(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            statsView.hidden = false
//            abilitesView.hidden = true
//            movesView.hidden = true
//            spritesView.hidden = true
//            evoView.hidden = true
            break
        case 1:
            statsView.hidden = true
//            abilitesView.hidden = false
//            movesView.hidden = false
//            spritesView.hidden = true
//            evoView.hidden = true
            break
        
        case 2:
            statsView.hidden = true
//            abilitesView.hidden = true
//            movesView.hidden = true
//            spritesView.hidden = false
//            evoView.hidden = false
            break
        default:
            break
        }
        
    }
    
    @IBAction func btnBack_Press(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
