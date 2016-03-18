//
//  Pokemon.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 2/29/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//
// CSV File has: id,identifier,species_id,height,weight,base_experience,order,is_default

import Foundation
import Alamofire

class Pokemon { //: NSObject
    
    //MARK: data source
    private var _resourceUrl : String = "\(URL_BASE)\(URL_POKEMON)"
    var myPokemonApiResult : Alamofire.Result<AnyObject, NSError>!
    var myPokemonSpeciesApiResult : Alamofire.Result<AnyObject, NSError>!
    
    //MARK: in csv file
    // ---- stats view ---- //
    private var _csvRowId : Int! //PokeId and Image ID
    private var _identifier: String! //same as PokeId and Image ID in the csv file
    private var _species_id: Int!
    private var _height: Int!
    private var _weight: Int!
    private var _base_experience: Int!
    private var _order: Int! //?
    private var _is_default: Bool! //?

    //MARK: others in app
    private var _description: String!
    private var _speciesName: String!
    private var _speciesUrl: String!
    private var _hitPoints: Int!
    private var _speed: Int!
    private var _type: String!
    private var _attack: Int!
    private var _defense: Int!
    private var _specialAttack: Int!
    private var _specialDefense: Int!
    
    //MARK: abilities
    private var _abilities = [String]()
    
    //MARK: moves
    private var _moves = [String]()
    
    //part of evo view
    private var _next_evolution_text: String = ""
    private var _next_evolution_id: Int = -1
    private var _next_evolution_level: Int = -1
    
    init(name:String, id:Int) {
        self._identifier = name
        self._csvRowId = id
        self._species_id = id
        self._resourceUrl.appendContentsOf("\(id)/")
        
    }
    
    
//    override func isEqual(object: AnyObject?) -> Bool {
//        if let rhs = object as? Pokemon {
//            if rhs.csvRowId == self.csvRowId {
//                return true
//            }
//        }
//        return false
//    }
    
    func downloadPokemonBasicDetails(completed: DownloadComplete) {
        let url = NSURL(string: self._resourceUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            //let result = response.result
            self.myPokemonApiResult = response.result
            if let dict = self.myPokemonApiResult.value as? Dictionary<String,AnyObject> {

                self.loadLevel1Stats(dict)
                
                if let statsDict = dict["stats"] as? [Dictionary<String, AnyObject>] where statsDict.count > 0 {
                    self.loadBasicStats(statsDict)
                }
                
                if let abilitiesArr = dict["abilities"] as? [Dictionary<String, AnyObject>] where abilitiesArr.count > 0 {
                    self.loadAbilities(abilitiesArr)
                }
                
                if let typesDict = dict["types"] as? [Dictionary<String, AnyObject>] where typesDict.count > 0 {
                    self.loadTypes(typesDict)
                } else {
                    self._type = ""
                }
                
                if let movesArr = dict["moves"] as? [Dictionary<String, AnyObject>] where movesArr.count > 0 {
                    self.loadMoves(movesArr)
                }
                
                if let evolutionsArr = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutionsArr.count > 0 {
                    self.loadEvolutions(evolutionsArr)
                }
                
                self.loadSpeciesNameAndUrl(dict)
                
                completed()
            }
        }
    }

    /* 
        species name and url required to get description
    */
    func downloadPokemonSpeciesDescription(speciesUrl: String, completed: DownloadComplete) {
        let url = NSURL(string: speciesUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            //let result = response.result
            self.myPokemonSpeciesApiResult = response.result
            found: if let speciesFullDict = self.myPokemonSpeciesApiResult.value as? Dictionary<String, AnyObject> {
                
                if let flavorTextDicts = speciesFullDict["flavor_text_entries"] as? [AnyObject] {
                    for flavorTextDict in flavorTextDicts {
                        if let langDict = flavorTextDict["language"] as? Dictionary<String, AnyObject> {
                            if let langName  = langDict["name"] as? String {
                                if langName == "en" {
                                    if let desc = flavorTextDict["flavor_text"] as? String {
                                        if desc != "" {
                                            self._description = desc.stringByReplacingOccurrencesOfString("\n",withString: " ")
                                        } else {
                                            self._description = "No description available"
                                        }
                                    }
                                    break found
                                }
                            }
                        }
                    }
                }
            }
            completed()
        }
        
    }
    
    
    //MARK: utility
    
    /*
        Call this before assigning new items to prevent previous entry content
        from being displayed with the new one
    
        TODO: all items, not just arrays.
    */
    func wipePokemon() {
        self._abilities.removeAll()
        self._moves.removeAll()
    }
    
    
    /*
        height, weight, base_experience
    */
    func loadLevel1Stats(topDict:Dictionary<String,AnyObject>) {
        if let weight = topDict["weight"] as? Int {
            self._weight = weight
        } else {
            self._weight = -1
        }
        
        if let height = topDict["height"] as? Int {
            self._height = height
        } else {
            self._height = -1
        }
        
        if let expBase = topDict["base_experience"] as? Int {
            self._base_experience = expBase
        } else {
            self._base_experience = -1
        }
        
    }
    
    /*
        hp, name, attack, defense, speed, special-defense, special-attack
    */
    func loadBasicStats(statsDict:[Dictionary<String,AnyObject>]) {
        
        for statItems in statsDict {
            if let statValue = statItems["base_stat"] as? Int  {
                
                if let statNameDict = statItems["stat"] as? Dictionary<String, String> where statNameDict.count > 0 {
                    let curName = statNameDict["name"]!
                    switch curName {
                    case "hp" :
                        self._hitPoints = statValue
                        break
                    case "attack" :
                        self._attack = statValue
                        break
                    case "defense" :
                        self._defense = statValue
                        break
                    case "speed" :
                        self._speed = statValue
                        break
                    case "special-defense" :
                        self._specialDefense = statValue
                        break
                    case "special-attack" :
                        self._specialAttack = statValue
                        break
                    default:
                        break
                    }
                    
                }
                
            }
        }
        
    }

    /*
        1-3 types
    */
    func loadTypes(typesDict:[Dictionary<String,AnyObject>]) {
        var tmpType: String = ""
        for typesItems in typesDict {
            
            if let typesItem = typesItems["type"] as? Dictionary<String, String> where typesItem.count > 0 {
                if let typeName = typesItem["name"] {
                    tmpType.appendContentsOf(typeName)
                    tmpType.appendContentsOf("\u{A0}")
                }
            }
        }
        //cut the last slash
        self._type = String(tmpType.characters.dropLast()).capitalizedString
    }
    
 
    /*
        1-3 abilities
    */
    func loadAbilities(abilitiesArr:[Dictionary<String,AnyObject>]) {
        for abilityDict in abilitiesArr {
            if let abilitySpec = abilityDict["ability"] as? Dictionary<String, String> where abilitySpec.count > 0 {
                let abilityName = abilitySpec["name"]
                if abilityName != "" {
                    self._abilities.append(abilityName!.capitalizedString)
                }
            }
        }
        self._abilities.sortInPlace ({ (element1:String, element2:String) -> Bool in
            return element1 < element2})
    }
    
    
    /* 
        species name and url
    */
    func loadSpeciesNameAndUrl(topDict:Dictionary<String,AnyObject>) {
        if let speciesDict = topDict["species"] as? Dictionary<String, String> where speciesDict.count > 0 {
            self._speciesName = speciesDict["name"]
            self._speciesUrl = speciesDict["url"] //use for description later
        } else {
            self._speciesName = "Unknown"
            self._speciesUrl = ""
        }
    }
    
    /*
        all moves
    */
    func loadMoves(movesArr: [Dictionary<String,AnyObject>]) {
        for moveDict in movesArr {
            if let moveSpec = moveDict["move"] as? Dictionary<String, String> where moveSpec.count > 0 {
                let moveName = moveSpec["name"]
                if moveName != "" {
                    self._moves.append(moveName!.capitalizedString)
                }
            }
        }
        self._moves.sortInPlace ({ (element1:String, element2:String) -> Bool in
            return element1 < element2})
    }
    
    /*
        all evolutions
    */
    func loadEvolutions(evolutionsArr: [Dictionary<String, AnyObject>]) {
        //get only the first evolution
        if let to = evolutionsArr[0]["to"] as? String  {
            self._next_evolution_text = to

            if  to.rangeOfString("mega") == nil {
                if let evo1Uri = evolutionsArr[0]["resource_uri"] as? String {
                    var evo2Uri = String(evo1Uri.characters.dropLast()) //lose the slash
                    evo2Uri = evo2Uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                    if let evoId = Int(evo2Uri) {
                        self._next_evolution_id = evoId
                    }
                }
                if let evo1Lev = evolutionsArr[0]["level"] as? Int {
                    self._next_evolution_level = evo1Lev
                }
            }
            
        }
    }
    
    /*
    
        species description for EN
    */
    func loadSpeciesDescription() {
        //preassigned in caller
    }
    
    //MARK: getter / setter
    var csvRowId: Int {
        get {
            return self._csvRowId
        }
    }
    
    var name: String {
        get {
            return self._identifier
        }
    }
    

    var speciesId: Int {
        get {
            return self._species_id
        }
        set {
            self._species_id = newValue
        }
    }
    
    var height: Int {
        get {
            return self._height
        }
        set {
            self._height = newValue
        }
    }
    
    var weight: Int {
        get {
            return self._weight
        }
        set {
            self._weight = newValue
        }
    }
    
    var baseExperience: Int {
        get {
            return self._base_experience
        }
    }
    
    var order: Int {
        get {
            return self._order
        }
    }
    
    var isDefault: Bool {
        get {
            return self._is_default
        }
    }

    var description: String {
        get {
            return self._description
        }
    }

    var speciesName: String {
        get {
            return self._speciesName
        }
    }
    
    var type: String {
        get {
            return self._type
        }
    }
    
    var attack: Int {
        get {
            return self._attack
        }
    }
    
    var defense: Int {
        get {
            return self._defense
        }
    }

    var speed: Int {
        get {
            return self._speed
        }
    }
    
    var hitPoints: Int {
        get {
            return self._hitPoints
        }
    }
    
    var specialAttack: Int {
        get {
            return self._specialAttack
        }
    }
    
    var specialDefense: Int {
        get {
            return self._specialDefense
        }
    }
    
    var abilities: [String] {
        get {
            return self._abilities
        }
    }
    
    /* comment */
    var moves: [String] {
        get {
            return self._moves
        }
    }
    
    /* comment */
    var next_evolution_text: String {
        get {
            return self._next_evolution_text
        }
    }
    
    /* comment */
    var next_evolution_id: Int {
        get {
            return self._next_evolution_id
        }
    }
    
    /* comment */
    var next_evolution_level: Int {
        get {
            return self._next_evolution_level
        }
    }
}