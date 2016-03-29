//
//  PokemonCache.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/16/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

/*
    This class enables performance improvements while the user is browsing.
*/
import Foundation

class PokemonCache : NSObject {
    
    private var _browseSet: [Pokemon]!
    
    //TODO: store image objects in core data
    private var _pokeImages: [Dictionary<String,String>]!
    
    override init() {
        _browseSet = [Pokemon]()
        _pokeImages = [Dictionary<String,String>]()
    }
    
    func addToCache(item: Pokemon) {
        
            if _browseSet.count <= 0 || !(_browseSet.contains({$0.csvRowId == item.csvRowId})) {
                _browseSet.append(item)
            }
    }
    
    func isInCache(item:Pokemon) -> Bool {
        if _browseSet.contains({$0.csvRowId == item.csvRowId}) {
            return true
        }
        return false
    }
    
    var count: Int {
        return _browseSet.count
    }
    
    var browseSet: [Pokemon] {
        get {
            return self._browseSet
        }
    }
}