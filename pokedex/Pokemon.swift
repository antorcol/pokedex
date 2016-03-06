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
    private var _csvRowId : Int!
    private var _identifier: String!
    private var _species_id: Int!
    private var _height: Int!
    private var _weight: Int!
    private var _base_experience: Int!
    private var _order: Int!
    private var _is_default: Bool!

    //MARK: others in app
    private var _description: String!
    private var _type: String!
    private var _attack: Int!
    private var _defense: Int!
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
        //let url = NSURL(fileURLWithPath: self._resourceUrl)
        Alamofire.request(.GET, self._resourceUrl).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String,AnyObject> {
                /* also available from csv */
                if let weight = dict["weight"] as? String {
                    self._weight = Int(weight)!
                } else { self._weight = -1 }
                if let height = dict["height"] as? String {
                    self._height = Int(height)!
                } else { self._height = -1 }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = attack
                    print("attack: \(attack)")
                } else {
                    self._attack = 0
                }
                if let defense = dict["defense"] as? Int {
                    self._defense = defense
                    print("defense: \(defense)")
                } else {
                    self._defense = 0
                }
                if let typesDict = dict["types"] as? [Dictionary<String, String>] where typesDict.count > 0 {

                    var tmpType: String = ""
                    for typesItems in typesDict {
                        if let typeName = typesItems["name"] {
                            tmpType.appendContentsOf(typeName)
                            tmpType.appendContentsOf("/")
                        }
                    }

                    self._type = String(tmpType.characters.dropLast()).capitalizedString
                } else {
                    self._type = ""
                }
                
                if let descriptionsDict = dict["descriptions"] as? [Dictionary<String, String>] where descriptionsDict.count > 0 {
                    if let uri = descriptionsDict[0]["resource_uri"]  {
                        
                        let urlStr :String = "\(URL_BASE)\(uri)"
                        Alamofire.request(.GET, urlStr).responseJSON(completionHandler: { response in
                            let destResult = response.result
                            if let descDict = destResult.value as? Dictionary<String, AnyObject> {
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print("description: \(description)")
                                }
                            }
                            
                            completed()
                        })
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutionsDict = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutionsDict.count > 0 {
                    
                    if let to = evolutionsDict[0]["to"] as? String  {
                        self._next_evolution_text = to
                        
                        
                        if  to.rangeOfString("mega") == nil {
                            if let evo1Uri = evolutionsDict[0]["resource_uri"] as? String {
                                var evo2Uri = String(evo1Uri.characters.dropLast()) //lose the slash
                                evo2Uri = evo2Uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon/", withString: "")
                                if let evoId = Int(evo2Uri) {
                                    self._next_evolution_id = evoId
                                }
                            }
                            if let evo1Lev = evolutionsDict[0]["level"] as? Int {
                                self._next_evolution_level = evo1Lev
                            }
                        }
                        
                    }
                }
                
            }
        }
    }
    
    //MARK: getter / setter
    var csvRowId: Int {
        get {
            return self._csvRowId
        }
//        set {
//            self._csvRowId = newValue
//        }
    }
    
    var name: String {
        get {
            return self._identifier
        }
//        set {
//            self._identifier = newValue
//        }
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
//        set {
//            self._base_experience = newValue
//        }
    }
    
    var order: Int {
        get {
            return self._order
        }
//        set {
//            self._order = newValue
//        }
    }
    
    var isDefault: Bool {
        get {
            return self._is_default
        }
//        set {
//            self._is_default = newValue
//        }
    }

    /* the pokemon description */
    var description: String {
        get {
            return self._description
        }
//        set {
//            self._description = newValue
//        }
    }

    var type: String {
        get {
            return self._type
        }
//        set {
//            self._type = newValue
//        }
    }
    
    /* comment */
    var attack: Int {
        get {
            return self._attack
        }
//        set {
//            self._attack = newValue
//        }
    }
    
    /* comment */
    var defense: Int {
        get {
            return self._defense
        }
//        set {
//            self._defense = newValue
//        }
    }

    /* comment */
    var next_evolution_text: String {
        get {
            return self._next_evolution_text
        }
//        set {
//            self._next_evolution_text = newValue
//        }
    }
    
    /* comment */
    var next_evolution_id: Int {
        get {
            return self._next_evolution_id
        }
//        set {
//            self._next_evolution_id = newValue
//        }
    }
    
    /* comment */
    var next_evolution_level: Int {
        get {
            return self._next_evolution_level
        }
//        set {
//            self._next_evolution_level = newValue
//        }
    }
}