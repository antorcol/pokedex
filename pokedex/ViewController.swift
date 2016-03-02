//
//  ViewController.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 2/29/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: IBOutlets and Vars
   
    var pokemon: [Pokemon] = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    
    
    @IBOutlet weak var collection: UICollectionView!
    
    //MARK: Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        
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
    
    
    
    func parsePokemonCSV() {
        
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")
        do {
            let csv = try CSV(contentsOfURL: path!)
            let rows = csv.rows
            for row in rows {
                let pokeId = Int(row["id"]!)!
                let name = row["identifier"]!
                let poke = Pokemon(name: name, id: pokeId)
                pokemon.append(poke)
            }
        } catch let err as NSError {
            print(err.description)
        }

        pokemon.sortInPlace ({ (element1:Pokemon, element2:Pokemon) -> Bool in
            return element1.id < element2.id})
        

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

    //MARK: Delegation requirements
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            let poke = pokemon[indexPath.row]
            cell.configureCell(poke)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        //TODO
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemon.count-1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
}

