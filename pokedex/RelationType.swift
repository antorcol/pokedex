//
//  RelationType.swift
//  pokedex
//
//  Created by Anthony Torrero Collins on 3/26/16.
//  Copyright © 2016 Anthony Torrero Collins. All rights reserved.
//

import Foundation

// For navigation among the relations in the Evolutions segment.
enum RelationType : String {
    case Ancestor = "ancestor"
    case Sibling = "sibling"
    case Descendant = "descendant"
}