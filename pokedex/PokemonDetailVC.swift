//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/3/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    //from csv: id (row id),identifier (name),species_id (img name, same as row id),height,weight,base_experience,order,is_default
    
    @IBOutlet weak var lblName: UILabel!            //CSV
    @IBOutlet weak var imgMain: UIImageView!        //CSV
    
    @IBOutlet weak var lblDescription: UILabel!     //DS
    @IBOutlet weak var lblType: UILabel!            //DL
    @IBOutlet weak var lblDefense: UILabel!         //DL
    @IBOutlet weak var lblHeight: UILabel!          //CSV
    @IBOutlet weak var lblPokeId: UILabel!          //DL
    @IBOutlet weak var lblWeight: UILabel!          //CSV
    @IBOutlet weak var lblBaseAttack: UILabel!      //DL
    @IBOutlet weak var imgCurrentEvo: UIImageView!
    @IBOutlet weak var imgNextEvo: UIImageView!     //DL
    @IBOutlet weak var lblEvolution: UILabel!       //DL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let img = UIImage(named: "\(pokemon.csvRowId)")
        imgMain.image = img
        self.imgCurrentEvo.image = img
        lblName.text = pokemon.name.capitalizedString
        lblHeight.text = String(pokemon.height)
        lblWeight.text = String(pokemon.weight)
        
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
        }
        
        let tgr = UITapGestureRecognizer(target:self, action:Selector("nextEvoImageTapped:"))
        self.imgNextEvo.userInteractionEnabled = true
        self.imgNextEvo.addGestureRecognizer(tgr)
    }

    func nextEvoImageTapped(sender: UIImageView) {
        pokemon = Pokemon(name: self.pokemon.next_evolution_text, id: self.pokemon.next_evolution_id)
        pokemon.downloadPokemonDetails { () -> () in
            self.updateUI()
        }
        
    }
    
    func updateUI() {
        self.lblName.text = self.pokemon.name.capitalizedString
        self.imgMain.image = UIImage(named: String(self.pokemon.speciesId))
        self.imgCurrentEvo.image = self.imgMain.image
        
        if pokemon.type != "" {
            self.lblType.text = pokemon.type
        }
        if self.pokemon.height > 0 {
            self.lblHeight.text = String(self.pokemon.height)
        } else {
            self.lblHeight.text = "Unknown"
        }
        if self.pokemon.weight > 0 {
            self.lblWeight.text = String(self.pokemon.weight)
        } else {
            self.lblWeight.text = "Unknown"
        }
        if String(self.pokemon.attack) != "" {
            self.lblBaseAttack.text = String(self.pokemon.attack)
        }
        if String(self.pokemon.speciesId) != "" {
            self.lblPokeId.text = String(self.pokemon.speciesId)
        }
        if String(self.pokemon.defense) != "" {
            self.lblDefense.text = String(self.pokemon.defense)
        }
        if self.pokemon.description != "" {
            self.lblDescription.text = self.pokemon.description
        }
        
        if self.pokemon.next_evolution_text != "" && self.pokemon.next_evolution_text.rangeOfString("mega") == nil {
            var str = "Next evolution: \(self.pokemon.next_evolution_text)"
            if self.pokemon.next_evolution_level > 0 {
                str.appendContentsOf("  Level: \(self.pokemon.next_evolution_level)")
            }
            self.lblEvolution.text = str
            self.imgNextEvo.hidden = false
        } else {
            self.lblEvolution.text = "No Evolution"
            self.imgNextEvo.hidden = true
            
        }
        
        if self.pokemon.next_evolution_id > 0 {
            self.imgNextEvo.image = UIImage(named: "\(self.pokemon.next_evolution_id)")
            self.imgNextEvo.hidden = false
        } else {
            self.imgNextEvo.hidden = true
        }

        
    }

    @IBAction func btnBack_Press(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }


}
