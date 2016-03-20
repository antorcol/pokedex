//
//  MainVC.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 2/29/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    //MARK: IBOutlets and Vars
   
    var pokemon: [Pokemon] = [Pokemon]()
    var filteredPokemon: [Pokemon] = [Pokemon]()
    var pokemonCache: PokemonCache = PokemonCache()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode: Bool = false
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        parsePokemonCSV()
        initAudio()
        
    }

    //MARK: Util
    func initAudio() {
        let pkMonMusicPath = NSBundle.mainBundle().pathForResource("MainTheme-Stadium", ofType: "mp3")
        let pkMonMusicPathURL = NSURL(fileURLWithPath: pkMonMusicPath!)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: pkMonMusicPathURL)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        } catch {
            print("No audio could be loaded")
        }
        
    }
    
    
    /* 
    
        this sets up what info we know from the csv file
        more available from the api
    */
    func parsePokemonCSV() {
        
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            for row in rows {
                let pokeId = Int(row["species_id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, id: pokeId)
                poke.speciesId = Int(row["species_id"]!)!
                poke.height = Int(row["height"]!)!
                poke.weight = Int(row["weight"]!)!
                pokemon.append(poke)
            }
        } catch let err as NSError {
            print(err.description)
        }

        pokemon.sortInPlace ({ (element1:Pokemon, element2:Pokemon) -> Bool in
            return element1.name < element2.name})
        

    }
    
    //MARK: IBActions
    
    @IBAction func btnSpeaker_Press(sender: UIButton) {
        if musicPlayer.playing {
            sender.alpha = 0.2
            musicPlayer.stop()
        } else {
            sender.alpha = 1.0
            musicPlayer.play()
        }
    }

    //MARK: Collection View
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            let poke : Pokemon!
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            cell.configureCell(poke)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        
        let poke : Pokemon!
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }

        if !pokemonCache.isInCache(poke) {
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PokeCell {

                let animation = CABasicAnimation(keyPath: "transform.scale")
                animation.toValue = NSNumber(float: 0.9)
                animation.duration = 0.5
                animation.repeatCount = 10.0
                animation.autoreverses = true
                cell.nameLabel.text = "...loading..."
                cell.nameLabel.layer.addAnimation(animation, forKey: nil)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let poke : Pokemon!
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        if !pokemonCache.isInCache(poke) {
            
            let speciesUrlStr = "\(URL_BASE)/api/v2/pokemon-species/\(poke.speciesId)/"
            poke.downloadPokemonSpeciesDescription(speciesUrlStr) { () -> () in
                print("description obtained")
                self.performSegueWithIdentifier("EnhancedDetailsVC", sender: poke)
                
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PokeCell {
                    cell.nameLabel.text = poke.name.capitalizedString
                }
                
            }
        } else {
            self.performSegueWithIdentifier("EnhancedDetailsVC", sender: poke)
        }
                
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
        } else {
            return pokemon.count
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    //MARK: Search Bar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
        } else {
            inSearchMode = true
            filteredPokemon = pokemon.filter {$0.name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil }
            collection.reloadData()
        }
    }
    
    
    //MARK: Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EnhancedDetailsVC" {
            if let detailsVC = segue.destinationViewController as? EnhancedDetailsVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                    detailsVC.pokemonCache = pokemonCache
                }
            }
        }
    }
}

