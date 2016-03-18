//
//  EnhancedDetailsVC.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/7/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit

class EnhancedDetailsVC: UIViewController,
                         UIScrollViewDelegate,
                         UICollectionViewDelegate,
                         UICollectionViewDataSource,
                         UICollectionViewDelegateFlowLayout {

    var pokemon: Pokemon!
    var pokemonCache: PokemonCache = PokemonCache()

    //MARK: Basic Stats - these are fixed in number
    @IBOutlet weak var lblPokeName: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblExperience: UILabel!
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
    @IBOutlet weak var lblDone: UILabel!
    
    //there's a maximum of 3 abilities
    @IBOutlet weak var lblAbilityOne: PokeAbilitiesLabelData!
    @IBOutlet weak var lblAbilityTwo: PokeAbilitiesLabelData!
    @IBOutlet weak var lblAbilityThree: PokeAbilitiesLabelData!
    //MARK: Moves
//    @IBOutlet weak var colMoves: UICollectionView!
    
    
    
    //    @IBOutlet weak var spritesView: UIView!
    //    @IBOutlet weak var evoView: UIView!
    
    
    //scroller
    @IBOutlet weak var mainHScroller: UIScrollView!
    @IBOutlet weak var stkStatistics: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pokeExists: Bool = false
        
        if(!pokemonCache.isInCache(pokemon)) {
            self.pokemon.wipePokemon()
            pokemonCache.addToCache(pokemon)
        } else {
            pokeExists = true
        }
        
        self.lblPokeName.text = pokemon.name.capitalizedString
        mainHScroller.delegate = self
        
        statsView.hidden = true
//        colMoves.hidden = true

        if !pokeExists {
            
            pokemon.downloadPokemonBasicDetails({ () -> () in
                self.updateUI()
//            self.colMoves.delegate = self
//            self.colMoves.dataSource = self
//            self.colMoves.reloadData()

                self.statsView.hidden = false
                print("updated UI")
                
            })
            
        } else {
            self.updateUI()
            self.statsView.hidden = false
        }
        

    }
    
    
    
    /* 
        make sure the content size of the scroller is appropriate
        got burned by this after I changed the view in IB
    */
    override func viewDidLayoutSubviews() {
    
        //TODO: adjust for moves, sprites segments
        let lblWidth: CGFloat = lblDone.frame.size.width
        
        let lblTopY : CGFloat = lblDone.frame.origin.y
        let lblSize : CGFloat = lblDone.frame.size.height
        
        let contentSize = CGSizeMake(lblWidth, lblTopY + lblSize + 5)
        mainHScroller.contentSize = contentSize
    
    }

    func updateUI() {
        self.imgMain.image = UIImage(named: String(self.pokemon.speciesId))
        if pokemon.type != "" {
            self.lblTypeVal.text = pokemon.type
            self.lblTypeVal.sizeToFit()
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
        
        if self.pokemon.baseExperience > 0 {
            self.lblExperience.text = String(self.pokemon.baseExperience)
        } else {
            self.lblExperience.text = "Unknown"
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
        
        //TODO: create the number of needed cells in a loop
        self.lblAbilityOne.hidden = true
        self.lblAbilityTwo.hidden = true
        self.lblAbilityThree.hidden = true
        if self.pokemon.abilities.count > 0 {
            self.lblAbilityOne.text = self.pokemon.abilities[0]
            self.lblAbilityOne.hidden = false
            if self.pokemon.abilities.count == 3 {
                self.lblAbilityTwo.text = self.pokemon.abilities[1]
                self.lblAbilityThree.text = self.pokemon.abilities[2]
                self.lblAbilityTwo.hidden = false
                self.lblAbilityThree.hidden = false
            } else if self.pokemon.abilities.count == 2 {
                self.lblAbilityTwo.text = self.pokemon.abilities[1]
                self.lblAbilityTwo.hidden = false
                self.lblAbilityThree.hidden = true
            }
        } else {
            self.lblAbilityOne.text = "None"
        }
        
    }

    //MARK: collectionView methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemon.moves.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(120, 17)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MoveCell", forIndexPath: indexPath) as? MoveCell {
            let moveName : String!
            moveName = pokemon.moves[indexPath.row]
            cell.configureCell(moveName)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    

    //MARK: Actions
    @IBAction func sgCategories_Pressed(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            statsView.hidden = false
//            colMoves.hidden = true
//            spritesView.hidden = true
//            evoView.hidden = true
            break
        case 1:
            statsView.hidden = true
//            colMoves.hidden = false
//            spritesView.hidden = true
//            evoView.hidden = true
            break
        
        case 2:
            statsView.hidden = true
 //           colMoves.hidden = true
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
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MainVC" {
            if let mainVC = segue.destinationViewController as? MainVC {
                    mainVC.pokemonCache = pokemonCache
            }
        }
    }

}
