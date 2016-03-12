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

class Pokemon {
    
    //MARK: data source
    private var _resourceUrl : String = "\(URL_BASE)\(URL_POKEMON)"
    
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
    
    
    //MARK: util
    func downloadPokemonDetails(completed: DownloadComplete) {
        //NOTE: the training vid had using nan NSURL in the request, but that 
            //doesn't work, returns nil. String works.
        let url = NSURL(string: self._resourceUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String,AnyObject> {

                /* I set to a negative value to indicate 'unknown' */
                //TODO: Set other integer values to -1 to indicate unknown?
                
                if let weight = dict["weight"] as? Int {
                    self._weight = weight
                } else {
                    self._weight = -1
                }
                
                if let height = dict["height"] as? Int {
                    self._height = height
                } else {
                    self._height = -1
                }
                
                if let expBase = dict["base_experience"] as? Int {
                    self._base_experience = expBase
                } else {
                    self._base_experience = -1
                }
                
                if let statsDict = dict["stats"] as? [Dictionary<String, AnyObject>] where statsDict.count > 0 {
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
                
// V1 stuff
//                if let attack = dict["attack"] as? Int {
//                    self._attack = attack
//                } else {
//                    self._attack = 0
//                }
//                
//                if let defense = dict["defense"] as? Int {
//                    self._defense = defense
//                } else {
//                    self._defense = 0
//                }
//                
//                
//                if let spatk = dict["special-attack"] as? Int {
//                    self._specialAttack = spatk
//                } else {
//                    self._specialAttack = 0
//                }
//                
//                if let spdef = dict["special-defense"] as? Int {
//                    self._specialDefense = spdef
//                } else {
//                    self._specialDefense = 0
//                }
//                
//                if let hp = dict["hp"] as? Int {
//                    self._hitPoints = hp
//                } else {
//                    self._hitPoints = 0
//                }
                
                if let speciesDict = dict["species"] as? Dictionary<String, String> where speciesDict.count > 0 {
                    self._speciesName = speciesDict["name"]
                    self._speciesUrl = speciesDict["url"] //use for description later
                } else {
                    self._speciesName = "Unknown"
                }
                
                if let typesDict = dict["types"] as? [Dictionary<String, AnyObject>] where typesDict.count > 0 {

                    var tmpType: String = ""
                    for typesItems in typesDict {
                        
                        if let typesItem = typesItems["type"] as? Dictionary<String, String> where typesItem.count > 0 {
                            if let typeName = typesItem["name"] {
                                tmpType.appendContentsOf(typeName)
                                tmpType.appendContentsOf("/")
                            }
                        }
                    }
                    //cut the last slash
                    self._type = String(tmpType.characters.dropLast()).capitalizedString
                } else {
                    self._type = ""
                }
                
                //v2 descriptions are buried
                if self._speciesUrl != nil && self._speciesUrl != "" {
                    
                    Alamofire.request(.GET, self._speciesUrl).responseJSON(completionHandler: { response in
                        let destResult = response.result
                        
                        //will use the sapphire version group
                        found: if let speciesFullDict = destResult.value as? Dictionary<String, AnyObject> {
                            if let flavorTextDicts = speciesFullDict["flavor_text_entries"] as? [AnyObject] {
                                for flavorTextDict in flavorTextDicts {
                                    if let langDict = flavorTextDict["language"] as? Dictionary<String, AnyObject> {
                                        if let langName  = langDict["name"] as? String {
                                            if langName == "en" {
                                                if let desc = flavorTextDict["flavor_text"] as? String {
                                                    if desc != "" {
                                                        self._description = desc
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
                    })
                    
                }
                
// v1 descriptions were much easier
//                if let descriptionsDict = dict["descriptions"] as? [Dictionary<String, String>] where descriptionsDict.count > 0 {
//                    //get only the first description
//                    if let uri = descriptionsDict[0]["resource_uri"]  {
//                        
//                        let urlStr :String = "\(URL_BASE)\(uri)"
//                        Alamofire.request(.GET, urlStr).responseJSON(completionHandler: { response in
//                            let destResult = response.result
//                            if let descDict = destResult.value as? Dictionary<String, AnyObject> {
//                                if let description = descDict["description"] as? String {
//                                    self._description = description
//                                    print("description: \(description)")
//                                }
//                            }
//                            
//                            completed()
//                        })
//                    }
//                } else {
//                    self._description = ""
//                }
                
                
                
                
//                if let evolutionsDict = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutionsDict.count > 0 {
//                    
//                    //get only the first evolution
//                    if let to = evolutionsDict[0]["to"] as? String  {
//                        self._next_evolution_text = to
//                        
//                        
//                        if  to.rangeOfString("mega") == nil {
//                            if let evo1Uri = evolutionsDict[0]["resource_uri"] as? String {
//                                var evo2Uri = String(evo1Uri.characters.dropLast()) //lose the slash
//                                evo2Uri = evo2Uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
//                                if let evoId = Int(evo2Uri) {
//                                    self._next_evolution_id = evoId
//                                }
//                            }
//                            if let evo1Lev = evolutionsDict[0]["level"] as? Int {
//                                self._next_evolution_level = evo1Lev
//                            }
//                        }
//                        
//                    }
//                }
                
            }
        }
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

    /* the pokemon description */
    var description: String {
        get {
            return self._description
        }
    }

    /* comment */
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
    
    /* comment */
    var attack: Int {
        get {
            return self._attack
        }
    }
    
    /* comment */
    var defense: Int {
        get {
            return self._defense
        }
    }

    /* comment */
    var speed: Int {
        get {
            return self._speed
        }
    }
    
    /* comment */
    var hitPoints: Int {
        get {
            return self._hitPoints
        }
    }
    
    /* comment */
    var specialAttack: Int {
        get {
            return self._specialAttack
        }
    }
    
    /* comment */
    var specialDefense: Int {
        get {
            return self._specialDefense
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