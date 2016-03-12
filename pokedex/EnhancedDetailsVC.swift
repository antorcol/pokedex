//
//  EnhancedDetailsVC.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/7/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit

class EnhancedDetailsVC: UIViewController, UIScrollViewDelegate {

    var pokemon: Pokemon!

    //MARK: Basic Stats
    @IBOutlet weak var lblPokeName: UILabel!
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
    @IBOutlet weak var sgCategories: UISegmentedControl!
    
    //    @IBOutlet weak var abilitesView: UIView!
    //    @IBOutlet weak var movesView: UIView!
    //    @IBOutlet weak var spritesView: UIView!
    //    @IBOutlet weak var evoView: UIView!
    
    
    //scroller
    @IBOutlet weak var mainHScroller: UIScrollView!
    @IBOutlet weak var stkStatistics: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainHScroller.delegate = self
        
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
        }
        
        statsView.hidden = false
//        abilitesView.hidden = true
//        movesView.hidden = true
//        spritesView.hidden = true
//        evoView.hidden = true
        

    }
    
    
    /* 
        I had wanted to hide the labels as they went behind the segmented control. However, 
        the timing is not right with the drag/scroll operation. It looks like I wouldn't have 
        control over changing the visibility as the scrolling was in progress. So I changed to a covering
        view farther forward in the UI.
    
        Update -- turns out all I needed to do was to turn on 'clip subviews' on the scroller. 
            problem solved.
    */
    /*
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let topOfCats :CGFloat = sgCategories.frame.origin.y
        let bottomOfCatsLocation : CGFloat = sgCategories.frame.size.height + topOfCats
        
        for case let subStack as UIStackView in stkStatistics.subviews {
        
            for case let lblField as UILabel in subStack.subviews {
                let topOfLabel: CGFloat = lblField.frame.origin.y
                let bottomOfLabelLocation: CGFloat = lblField.frame.size.height + topOfLabel
                if bottomOfLabelLocation <= bottomOfCatsLocation && lblField.alpha != 0.0 {
                    lblField.alpha = 0.2
                } else if bottomOfLabelLocation > bottomOfCatsLocation {
                    lblField.alpha = 1.0
                }
                
            }
        }
        
    }
    */
    
    /* 
        make sure the content size of the scroller is appropriate
    */
    override func viewDidLayoutSubviews() {
    
        let stkWidth: CGFloat = stkStatistics.frame.size.width
        
        let topY : CGFloat = stkStatistics.frame.origin.y
        let stkSize : CGFloat = stkStatistics.frame.size.height
        
        let contentSize = CGSizeMake(stkWidth, topY + stkSize + 20)
        mainHScroller.contentSize = contentSize
    
    }

    func updateUI() {
//        self.lblName.text = self.pokemon.name.capitalizedString
        self.imgMain.image = UIImage(named: String(self.pokemon.speciesId))
        self.lblPokeName.text = pokemon.name.capitalizedString
        if pokemon.type != "" {
            self.lblTypeVal.text = pokemon.type
        } else {
            self.lblTypeVal.text = "Unknown"
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
        //TODO: add label
        if self.pokemon.baseExperience > 0 {
            //
        } else {
            //
        }
        if String(self.pokemon.attack) != "" {
            self.lblAttackVal.text = String(self.pokemon.attack)
        }else {
            self.lblAttackVal.text = "Unknown"
        }
        if String(self.pokemon.defense) != "" {
            self.lblDefenseVal.text = String(self.pokemon.defense)
        }else {
            self.lblDefenseVal.text = "Unknown!"
        }
        if String(self.pokemon.speed) != nil {
            self.lblSpeedVal.text = String(self.pokemon.speed)
        } else {
            self.lblSpeedVal.text = "Unknown"
        }
        if String(self.pokemon.hitPoints) != nil {
            self.lblHitPointsVal.text = String(self.pokemon.hitPoints)
        } else {
            self.lblHitPointsVal.text = String("0")
        }
        if String(self.pokemon.specialAttack) != nil {
            self.lblSpAttackVal.text = String(self.pokemon.specialAttack)
        } else {
            self.lblSpAttackVal.text = "Unknown"
        }
        if String(self.pokemon.specialDefense) != nil {
        self.lblSpDefenseVal.text = String(self.pokemon.specialDefense)
        } else {
        self.lblSpDefenseVal.text = "Unknown"
        }
        if String(self.pokemon.speciesName) != "" {
            self.lblSpeciesVal.text = String(self.pokemon.speciesName).capitalizedString
        } else {
            self.lblSpeciesVal.text = "Unknown"
        }
        
        if self.pokemon.description != "" {
            self.lblBaseDescription.text = self.pokemon.description
        } else {
            self.lblBaseDescription.text = "Unknown"
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
