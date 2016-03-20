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
    var activeView : String = "statsView" {
        didSet {
            if activeView == "statsView" {
                statsView.hidden = false
                movesView.hidden = true
            }
            if activeView == "movesView" {
                statsView.hidden = true
                movesView.hidden = false
            }
            if activeView == "spritesView" {
                statsView.hidden = true
                movesView.hidden = true
            }
        }
    }

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
    
    //there's a maximum of 3 abilities
    @IBOutlet weak var lblAbilityOne: PokeAbilitiesLabelData!
    @IBOutlet weak var lblAbilityTwo: PokeAbilitiesLabelData!
    @IBOutlet weak var lblAbilityThree: PokeAbilitiesLabelData!

    //MARK: Moves
    @IBOutlet weak var movesView: UIView!
    @IBOutlet weak var movesCol: UICollectionView!
    
    
    //    @IBOutlet weak var spritesView: UIView!
    //    @IBOutlet weak var evoView: UIView!
    
    
    //scroller
    @IBOutlet weak var mainHScroller: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        statsView.translatesAutoresizingMaskIntoConstraints = false
//        movesView.translatesAutoresizingMaskIntoConstraints = false
        
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
        movesView.hidden = true
        //spritesView.hidden = true

        if !pokeExists {
            
            pokemon.downloadPokemonBasicDetails({ () -> () in
                self.updateUI()
                
                self.movesCol.delegate = self
                self.movesCol.dataSource = self
                self.movesCol.reloadData()

                self.activeView = "statsView"
                
            })
            
        } else {
            self.updateUI()
            self.movesCol.delegate = self
            self.movesCol.dataSource = self
            
            self.activeView = "statsView"
        }
        

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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSize(width: (collectionView.frame.size.width - 10)/2, height: 17)
//    }


    //MARK: Actions
    @IBAction func sgCategories_Pressed(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.activeView = "statsView"
//            statsView.hidden = false
//            movesView.hidden = true
//            spritesView.hidden = true
//            evoView.hidden = true
            break
        case 1:
            self.activeView = "movesView"
//            statsView.hidden = true
//            movesView.hidden = false
//            spritesView.hidden = true
//            evoView.hidden = true
            break
        
        case 2:
            self.activeView = "spritesView"
//            statsView.hidden = true
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
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MainVC" {
            if let mainVC = segue.destinationViewController as? MainVC {
                    mainVC.pokemonCache = pokemonCache
            }
        }
    }

}
