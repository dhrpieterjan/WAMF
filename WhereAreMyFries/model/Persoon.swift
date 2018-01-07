//
//  Persoon.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 28/10/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import Foundation

struct Persoon: Hashable {
    
    let naam:String
    
    var hashValue: Int
    
    static func ==(lhs: Persoon, rhs: Persoon) -> Bool {
        return lhs.naam == rhs.naam
    }
    
}
