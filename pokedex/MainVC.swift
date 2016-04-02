//
//  MainVC.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 2/29/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    //MARK: IBOutlets and Vars
   
    var pokemon: [Pokemon] = [Pokemon]()
    var filteredPokemon: [Pokemon] = [Pokemon]()
    var pokemonFavs: [Pokemon] = [Pokemon]()
    var pokemonCache: PokemonCache = PokemonCache()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode: Bool = false
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var btnCache: UIButton!
    @IBOutlet weak var btnFavs: UIButton!
    
    //MARK: Viewcontroller Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        parsePokemonCSV()
        initAudio()
        
    }

    override func viewWillAppear(animated: Bool) {
        
        //reload the collection so that the cached pokemon will have the correct highlight
        if pokemonCache.count > 0 {
            self.collection.reloadData()
        }
    }
    
    //MARK: Util
    // I chose the battle music for the app, mostly because it was the longest clip
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
        The pokemon.csv file has basic info on all the 780+ pokemon.
        A performance issue.
        TODO: Sync the file periodically.
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
            //there are three ways to filter the collection:
            //  search bar typing,
            //  favorites
            //  cached items
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
            } else if btnFavs.selected {
                poke = pokemonFavs[indexPath.row]
            } else if btnCache.selected {
                poke = pokemonCache.browseSet[indexPath.row]
            } else {
                poke = pokemon[indexPath.row]
            }
            
            let highlightCell: Bool = pokemonCache.isInCache(poke)
            
            cell.configureCell(poke, isInCache: highlightCell)
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    // I pull the highlight so that I can adjust the pokemon title to be 'loading'
    // This is basically a time delay hack. Stuff takes a while to load down.
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        
        let poke : Pokemon!
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else if btnFavs.selected {
            poke = pokemonFavs[indexPath.row]
        } else if btnCache.selected {
            poke = pokemonCache.browseSet[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }

        if !pokemonCache.isInCache(poke) {
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PokeCell {
                cell.nameLabel.pulseOn("...loading...")
            }
        }
    }
    
    
    // clicking a cell (outside the favorites button) navigates to that pokemon.
    //  if cached, it pulls from the pokemonCache set
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let poke : Pokemon!
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else if btnFavs.selected {
            poke = pokemonFavs[indexPath.row]
        } else if btnCache.selected {
            poke = pokemonCache.browseSet[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        if !pokemonCache.isInCache(poke) {
            //I load the description first in the initial call.
            // The V2 JSon is structured in such a way that I decided to compartmentalize
            //  the downloading to what I can get from the single url(s), and not nest them.
            //  There is a timing issue involved as well.
            let speciesUrlStr = "\(URL_BASE)/api/v2/pokemon-species/\(poke.speciesId)/"
            poke.downloadPokemonSpeciesDescription(speciesUrlStr) { () -> () in
                self.performSegueWithIdentifier("EnhancedDetailsVC", sender: poke)
                
                if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? PokeCell {
                    cell.nameLabel.pulseOff(poke.name.capitalizedString)
                }
                
            }
        } else {
            //The item is in the cache, just get it.
            self.performSegueWithIdentifier("EnhancedDetailsVC", sender: poke)
        }
                
    }
    
    
    // restrict the count to the appropriate set.
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if inSearchMode {
            return filteredPokemon.count
        } else if btnFavs.selected {
            return pokemonFavs.count
        } else if btnCache.selected {
            return pokemonCache.browseSet.count
        } else {
            return pokemon.count
        }
    }
    
    //just one section
    // I tried at one point to have headers for the collections, but it became an unwieldy nightmare.
    //   I'll try that with my next app.
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Standard collection cell size.
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    //MARK: Search Bar
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    
    //TODO: The search bar loses focus when the backspace key deletes the final character in the search bar.
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            collection.reloadData()
            //view.endEditing(true)
        } else {
            inSearchMode = true
            filteredPokemon = pokemon.filter {$0.name.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil }
            collection.reloadData()
        }
    }
    
    
    //MARK: Favorites and Cache
    // Right now, the favorites and cache displays are 
    //  exclusive
    @IBAction func btnFavs_Press(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected {
            btnCache.selected = false
            sender.highlighted = true
            filteredPokemon = pokemonFavs
            collection.reloadData()
        } else {
            sender.highlighted = false
            view.endEditing(true)
            collection.reloadData()
        }
    }
    
    
    @IBAction func btnCache_Press(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected {
            sender.highlighted = true
            btnFavs.selected = false
            collection.reloadData()
        } else {
            sender.highlighted = false
            view.endEditing(true)
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

