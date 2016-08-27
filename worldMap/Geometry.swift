//
//  Geometry.swift
//  worldMap
//
//  Created by Mohammad Awwad on 8/27/16.
//  Copyright © 2016 awwadeto. All rights reserved.
//

import Foundation

class Geometry  {
    
    struct Keys {
        static let Type = "type"
        static let Coordinates = "coordinates"
    }
    
    var type : String!
    var coordinates : NSArray!
    
    init(type : String){
        self.type = type
    }
}