//
//  FavForPers.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 07/01/2018.
//  Copyright © 2018 Pieter-Jan Philips. All rights reserved.
//

import Foundation
import CloudKit

class FavForPers {
    
    let recordID: CKRecordID?
    let snacks: [Snack]?
    let opmerking: String?
    let naam: String?
    
    init(recordID: CKRecordID, snacks: [Snack], opmerking: String, naam: String) {
        self.recordID = recordID
        self.snacks = snacks
        self.opmerking = opmerking
        self.naam = naam
    }
    
    init() {
        self.recordID = nil
        self.snacks = []
        self.opmerking = ""
        self.naam = ""
    }
    
    func toString() -> String {
        var string = "\(opmerking ?? "Geen opmerkingen") \n"
        for snack in snacks! {
            string.append("\t- \(snack.naam)\n")
        }
        
        return string
    }
    
}
