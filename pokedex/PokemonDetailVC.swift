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
    
    @IBOutlet weak var lblName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        lblName.text = pokemon.id.capitalizedString
    }


    @IBAction func btnBack_Press(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
