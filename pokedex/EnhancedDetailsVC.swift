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
    var activeView : String = "noView" {
        didSet {
            if activeView == "statsView" {
                statsView.hidden = false
                movesView.hidden = true
                evoView.hidden = true
            }
            if activeView == "movesView" {
                statsView.hidden = true
                movesView.hidden = false
                evoView.hidden = true
            }
            if activeView == "spritesView" {
                statsView.hidden = true
                movesView.hidden = true
                evoView.hidden = false
            }
            if activeView == "noView" {
                statsView.hidden = true
                movesView.hidden = true
                evoView.hidden = true
            }
        }
    }

    //MARK: Constants
    let MOVES_COL_TAG = 10
    let SPRITES_COL_TAG = 20
    let DESCENDANTS_COL_TAG = 30
    
    
    //MARK: Basic Stats - these are fixed in number
    @IBOutlet weak var lblPokeName: UILabel!
    @IBOutlet weak var imgMain: UIImageView!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var lblBaseDescription: UILabel!
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
    
    //Abilities: maximum of 3
    @IBOutlet weak var lblAbilityOne: PokeAbilitiesLabelData!
    @IBOutlet weak var lblAbilityTwo: PokeAbilitiesLabelData!
    @IBOutlet weak var lblAbilityThree: PokeAbilitiesLabelData!

    //MARK: Stats view, which contains all stats info. Has a static 'collection'
    @IBOutlet weak var statsView: UIView!

    //MARK: Moves
    @IBOutlet weak var movesView: UIView!
    @IBOutlet weak var movesCol: UICollectionView!
    
    //MARK: Evo Images
    @IBOutlet weak var evoView: UIView!
    @IBOutlet weak var spritesCol: UICollectionView!
    
    //Ancestor: maximum of one
    @IBOutlet weak var imgAncestor: UIImageView!
    @IBOutlet weak var lblAncestor: PokeDataLabelData!
    
    //Descendants: 0..Many
    @IBOutlet weak var descendantsCol: UICollectionView!
    
    @IBOutlet weak var lblNoDescs: PokeDataLabelData!
    
    //scroller
    @IBOutlet weak var mainHScroller: UIScrollView!
    
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

        //TODO: pulseOn not working here
        self.lblBaseDescription.pulseOn("...loading...")
        mainHScroller.delegate = self
        self.activeView = "noView"

        
        
        if !pokeExists {
            
            pokemon.downloadPokemonBasicDetails({ () -> () in
                self.updateUI()
                
                self.movesCol.delegate = self
                self.movesCol.dataSource = self
                
                self.spritesCol.delegate = self
                self.spritesCol.dataSource = self
                
                //I wanted to have this unnested, but it wouldn't work
                if !self.pokemon.hasEvoinfo {
                    
                    self.pokemon.downLoadEvolutions(self.pokemon.evolutionChainUrl) { () -> () in
                        
                        self.descendantsCol.delegate = self
                        self.descendantsCol.dataSource = self
                        self.descendantsCol.reloadData()
                    }
                }
                

                self.lblBaseDescription.pulseOff(self.pokemon.description)
                self.activeView = "statsView"
            })
            
            
        } else {
            self.updateUI()
            self.movesCol.delegate = self
            self.movesCol.dataSource = self
            self.spritesCol.delegate = self
            self.spritesCol.dataSource = self
            self.descendantsCol.delegate = self
            self.descendantsCol.dataSource = self
            self.activeView = "statsView"
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.navigateAncestor))
        
        imgAncestor.addGestureRecognizer(tap)
        imgAncestor.userInteractionEnabled = true
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
        
        //add the ancestor name, if it exists
        if self.pokemon.ancestorSpeciesName != "" {
            self.lblAncestor.text = self.pokemon.ancestorSpeciesName
        } else {
            self.lblAncestor.text = "None"
        }
        
        //add the ancestor image, if it exists
        if self.pokemon.ancestorSpeciesId > 0 {
            self.imgAncestor.image = UIImage(named: String(self.pokemon.ancestorSpeciesId))
            self.imgAncestor.hidden = false
        } else {
            self.imgAncestor.hidden = true
        }
        
        
    }

    //MARK: collectionView methods
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == MOVES_COL_TAG {
            return self.pokemon.moves.count
        } else if collectionView.tag == SPRITES_COL_TAG {
            return self.pokemon.spriteNames.count
        } else if collectionView.tag == DESCENDANTS_COL_TAG {
            return  self.pokemon.descendants.count
        } else {
            return 1
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView.tag == MOVES_COL_TAG {
            return CGSizeMake(120, 17)
        } else if collectionView.tag == SPRITES_COL_TAG {
            return CGSizeMake(100, 100)
        } else if collectionView.tag == DESCENDANTS_COL_TAG {
            return CGSizeMake(100, 120)
        }
        return CGSizeMake(110, 140)
    }
    
    /* 
        to have multiple collections on the same view you need to distinguish between the 
        collections. I did this via tags on the collections
    */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == DESCENDANTS_COL_TAG {
            if let descendantCell = collectionView.dequeueReusableCellWithReuseIdentifier("DescendantCell", forIndexPath: indexPath) as? DescendantCell {
                
                let descendantDict = self.pokemon.descendants[indexPath.row]
                descendantCell.configureCell(descendantDict["name"]!, descendantId: descendantDict["id"]!)
                
                return descendantCell
            }
            
        } else if collectionView.tag == MOVES_COL_TAG {
            if let moveCell = collectionView.dequeueReusableCellWithReuseIdentifier("MoveCell", forIndexPath: indexPath) as? MoveCell {
                let moveName : String!
                moveName = pokemon.moves[indexPath.row]
                moveCell.configureCell(moveName)
                return moveCell
            }
        } else if collectionView.tag == SPRITES_COL_TAG {
            if let spriteCell = collectionView.dequeueReusableCellWithReuseIdentifier("SpriteCell", forIndexPath: indexPath) as? SpriteCell {
                let spriteName = self.pokemon.spriteNames[indexPath.row] //key is the same as the sprite name
                let spriteUrl: String = self.pokemon.spriteUrls[indexPath.row]
                
                spriteCell.configureCell(spriteName, spriteUrlStr: spriteUrl)
                return spriteCell
            }
        } 
        
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    

    //MARK: Actions
    @IBAction func sgCategories_Pressed(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.activeView = "statsView"
            break
        case 1:
            self.activeView = "movesView"
            break
        case 2:
            self.descendantsCol.reloadData()
            
            //must load species first
            // this is an alamofire call
            
//            if !pokemon.hasEvoinfo {
//                
//                self.pokemon.downLoadEvolutions(self.pokemon.evolutionChainUrl) { () -> () in
//
//                    self.descendantsCol.reloadData()
//                    self.activeView = "spritesView"
//                }
//            } else {
                self.activeView = "spritesView"
//            }
            
            break
        default:
            break
        }
        
    }
    
    
    @IBAction func btnBack_Press(sender: UIButton) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func navigateAncestor() {
        let poke :Pokemon = Pokemon(name: self.pokemon.ancestorSpeciesName, id: self.pokemon.ancestorSpeciesId)

        let speciesUrlStr = "\(URL_BASE)/api/v2/pokemon-species/\(poke.speciesId)/"
        self.imgMain.image = UIImage(named: String(poke.speciesId))
        self.lblBaseDescription.text = "...navigating ancestor..."

        self.activeView = "noView"
        self.pokemon = poke
        
        if !pokemonCache.isInCache(poke) {
            
            poke.downloadPokemonSpeciesDescription(speciesUrlStr) { () -> () in
                self.lblBaseDescription.text = poke.description
                self.imgMain.image = UIImage(named: String(poke.speciesId))
                self.sgCategories.selectedSegmentIndex = 0
                self.viewDidLoad()
            }
        } else {
            self.lblBaseDescription.text = poke.description
            self.imgMain.image = UIImage(named: String(poke.speciesId))
            self.sgCategories.selectedSegmentIndex = 0
            self.viewDidLoad()
        }
        
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
