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
                         UITableViewDelegate,
                         UITableViewDataSource,
                         UICollectionViewDelegate,
                         UICollectionViewDataSource,
                         UICollectionViewDelegateFlowLayout {

    var pokemon: Pokemon!

    //MARK: Basic Stats
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
    
    //MARK: Abilities is in StatsView
    @IBOutlet weak var tblAbilities: UITableView!
    
    
    //MARK: Moves
    @IBOutlet weak var colMoves: UICollectionView!
    
    
    
    //    @IBOutlet weak var spritesView: UIView!
    //    @IBOutlet weak var evoView: UIView!
    
    
    //scroller
    @IBOutlet weak var mainHScroller: UIScrollView!
    @IBOutlet weak var stkStatistics: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.lblPokeName.text = pokemon.name.capitalizedString
        //print("Pokemon: \(pokemon.name), \(pokemon.speciesId)")
        mainHScroller.delegate = self
        
        statsView.hidden = true
        colMoves.hidden = true
        
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
            //place these here so that the table isn't loaded until the data is complete.
            self.tblAbilities.delegate = self
            self.tblAbilities.dataSource = self
            self.tblAbilities.reloadData()
            
            self.colMoves.delegate = self
            self.colMoves.dataSource = self
            self.colMoves.reloadData()
            
            self.statsView.hidden = false
            
            
        }
        
        

    }
    
    
    
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
    

    
    //MARK: tableView Methods
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == self.tblAbilities {
            if let cell = tableView.dequeueReusableCellWithIdentifier("AbilityCell", forIndexPath: indexPath) as? AbilityCell {
                cell.configureCell(pokemon.abilities[indexPath.row])
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tblAbilities {
            return self.pokemon.abilities.count
        }
        
        return 1
    }
    
    //always 1 section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: Actions
    @IBAction func sgCategories_Pressed(sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            statsView.hidden = false
            colMoves.hidden = true
//            spritesView.hidden = true
//            evoView.hidden = true
            break
        case 1:
            statsView.hidden = true
            colMoves.hidden = false
//            spritesView.hidden = true
//            evoView.hidden = true
            break
        
        case 2:
            statsView.hidden = true
            colMoves.hidden = true
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
