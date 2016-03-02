//
//  Pokemon.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 2/29/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//
// CSV File has: id,identifier,species_id,height,weight,base_experience,order,is_default

import Foundation

class Pokemon {
    var _csvRowId : Int!
    var _identifier: String!
    var _species_id: Int!
    var _height: Int!
    var _weight: Int!
    var _base_experience: Int!
    var _order: Int!
    var _is_default: Bool!

    
    init(name:String, id:Int) {
        self._identifier = name
        self._csvRowId = id
    }
    
    
    //MARK: getter / setter
    var csvRowId: Int {
        get {
            return self._csvRowId
        }
        set {
            self._csvRowId = newValue
        }
    }
    
    var id: String {
        get {
            return self._identifier
        }
        set {
            self._identifier = newValue
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
        set {
            self._base_experience = newValue
        }
    }
    
    var order: Int {
        get {
            return self._order
        }
        set {
            self._order = newValue
        }
    }
    
    var isDefault: Bool {
        get {
            return self._is_default
        }
        set {
            self._is_default = newValue
        }
    }




}