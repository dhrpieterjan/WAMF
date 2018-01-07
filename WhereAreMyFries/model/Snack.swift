//
//  Snack.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 28/10/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import Foundation
import CloudKit

class Snack : Hashable{
    
    let naam:String
    let image: String
    let categorie: String
    let recordID: CKRecordID
    var hashValue: Int = 0
    
    static func ==(lhs: Snack, rhs: Snack) -> Bool {
        return lhs.image == rhs.image
    }
    
    init(naam: String, image: String, categorie: String, recordId: CKRecordID) {
        self.naam = naam
        self.image = image
        self.categorie = categorie
        self.hashValue = 0
        self.recordID = recordId
    }
    
}
