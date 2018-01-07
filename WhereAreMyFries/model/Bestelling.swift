//
//  Bestelling.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 28/10/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import Foundation
import CloudKit

class Bestelling {
    
    let naam:String
    var recordID: CKRecordID?
    var personen: [CKRecordID]
    var bestForPerson: [CKRecordID]
    var creationDate: Date
    var aantalSubs: Int {
        get {
            return personen.count
        }
    }
    
    var qrString: String {
        get{
            return "\(self.naam)\(self.creationDate)"
        }
    }
    
    let bestellingenPerPersoon: [Persoon: PersoonlijkeBestelling] = [:]
    
    init(naam: String) {
        self.naam = naam
        self.personen = []
        self.bestForPerson = []
        self.creationDate = Date()
    }
    
    init(naam: String, personen: [CKRecordID]) {
        self.naam = naam
        self.personen = personen
        self.bestForPerson = []
        self.creationDate = Date()
    }
    
    init(naam: String, personen: [CKRecordID], bestForPerson: [CKRecordID]) {
        self.naam = naam
        self.personen = personen
        self.bestForPerson = bestForPerson
        self.creationDate = Date()
    }
    
    init(naam: String, personen: [CKRecordID], creationDate: Date) {
        self.naam = naam
        self.personen = personen
        self.bestForPerson = []
        self.creationDate = creationDate
    }
    
    init(naam: String, personen: [CKRecordID], bestForPerson: [CKRecordID], creationDate: Date) {
        self.naam = naam
        self.personen = personen
        self.bestForPerson = bestForPerson
        self.creationDate = creationDate
    }
    
}

extension Bestelling: Equatable {
    static func ==(lhs: Bestelling, rhs: Bestelling) -> Bool {
        return lhs.naam == rhs.naam
    }
    
}
