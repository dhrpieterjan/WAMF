//
//  BestellingenRepository.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 04/11/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import CloudKit

class BestellingenRepository {
    
    var userRecordID : CKRecordID?
    var database = CKContainer.default().publicCloudDatabase
    var bestellingen = [Bestelling]()
    
    func getBestellingenForUser(completionHandler: @escaping ([Bestelling]) -> Void) {
        
        self.getUserRecorID { (userRecordID) in
            
            self.database.fetch(withRecordID: userRecordID) { record, error in
                guard let record = record, error == nil else {
                    // show off your error handling skills
                    return
                }

                if let bestellingenReferanceSubsForUser = record.object(forKey: "bestSubs") as! [CKReference]? {
                    var bestellingenRecordSubsForUser = [CKRecordID]()
                    
                    if bestellingenReferanceSubsForUser.count == 0 {
                        DispatchQueue.main.async {
                            completionHandler(self.bestellingen)
                        }
                        return
                    }
                    
                    for bestelling in bestellingenReferanceSubsForUser {
                        bestellingenRecordSubsForUser.append(bestelling.recordID)
                    }
                    
                    let predicate = NSPredicate(format: "recordID IN %@", bestellingenRecordSubsForUser)
                    let query = CKQuery(recordType: "Bestelling", predicate: predicate)
                    
                    self.database.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                        print(error ?? "no error")
                        if let records = records {
                            
                            for record in records {
                                let best = Bestelling(naam: record.object(forKey: "name") as! String,                                                                                                       personen: record.object(forKey: "persons") as! [CKRecordID],
                                                      creationDate: record.creationDate!)
                                
                                best.recordID = record.recordID
                                
                                self.bestellingen.append(best)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            completionHandler(self.bestellingen.sorted(by: { $0.creationDate > $1.creationDate}))
                        }
                        
                    })
                } else {
                    DispatchQueue.main.async {
                        completionHandler(self.bestellingen)
                    }
                }

            }

        }

    }
    
    func saveFavForPerson(snacks: [Snack], opmerking: String, naam: String, completionHandler: @escaping () -> Void ){
        self.getUserRecorID { (userRecordID) in
            
            self.database.fetch(withRecordID: userRecordID) { record, error in
                guard let record = record, error == nil else {
                    // show off your error handling skills
                    return
                }
                
                
                let favForPerson = CKRecord(recordType: "FavForPerson")
                var snacksRID: [CKReference] = []
                for snack in snacks {
                    snacksRID.append(CKReference(recordID: snack.recordID, action: CKReferenceAction.none))
                }
                favForPerson.setValue(snacksRID, forKey: "snacks")
                favForPerson.setValue(opmerking, forKey: "opmerking")
                favForPerson.setValue(naam, forKey: "naam")
                let ownerRef = CKReference(record: record, action: CKReferenceAction.none)
                favForPerson.setValue(ownerRef, forKey: "owner")
                
                self.database.save(favForPerson, completionHandler: { (_, error) in
                    completionHandler()
                })
            }
        }
    }
    
    func getAllBetellingenRecrods(completionHandler: @escaping ([CKRecord]) -> Void){
        
        var bestellingenRecords = [CKRecord]()
        
        let query = CKQuery(recordType: "Bestelling", predicate: NSPredicate(value: true))
        self.database.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
            print(error ?? "no error")
            if let records = records {
                
                bestellingenRecords = records
                
            }
            
            DispatchQueue.main.async {
                print("Got all bestellingenRecords")
                completionHandler(bestellingenRecords)
            }
            
            
        })
        
    }
    
    func getFavBestellingn(completionHandler: @escaping ([FavForPers]) -> Void){
        self.getUserRecorID { (userRecordID) in
            
            self.database.fetch(withRecordID: userRecordID) { record, error in
                guard let record = record, error == nil else {
                    // show off your error handling skills
                    return
                }
                
                let predicate = NSPredicate(format: "owner == %@", userRecordID)
                let query = CKQuery(recordType: "FavForPerson", predicate: predicate)
                
                self.database.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                    
                    var favs: [FavForPers] = []
                    
                    if error == nil {
                        
                        if let records = records {
                            
                            for record in records {
                                
                                let snacksInFav = record.object(forKey: "snacks") as! [CKRecordID]
                                var snacks: [Snack] = []
                                
                                let predicate = NSPredicate(format: "recordID IN %@", snacksInFav)
                                let query = CKQuery(recordType: "Snack", predicate: predicate)
                                
                                self.database.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                                    if error != nil {
                                        
                                    } else if let records = records {
                                        
                                        
                                        for record in records {
                                            snacks.append(Snack(
                                                naam: record.object(forKey: "naam") as! String,
                                                image: record.object(forKey: "image") as! String,
                                                categorie: record.object(forKey: "categorie") as! String,
                                                recordId: record.recordID))
                                        }
                                        
                                    }
                                    
                                    let naam = record.object(forKey: "naam") as! String
                                    let opmerking = record.object(forKey: "opmerking") as! String
                                    print(opmerking)
                                    
                                    favs.append(FavForPers(recordID: record.recordID, snacks: snacks, opmerking: opmerking, naam: naam))
                                    
                                    completionHandler(favs)
 
                                })
                                
                                
                                
                            }
                            
                        }
                        
                        
                    } else{
                        print (error)
                    }
                    
                    print(favs)
                    
                    
                })
                
            }
        }
    }
    
    func getUserRecorID(gotUserID: @escaping (CKRecordID) -> Void){
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                // error handling magic
                return
            }
            
            //print("Got userRecordID: \(recordID)")
            gotUserID(recordID)
            
        }
    }
    
    func getRecordBy(recordName: String, gotRecord: @escaping (CKRecord?) -> Void){
        
        let bestellingRecordId = CKRecordID(recordName: recordName)
        
        self.database.fetch(withRecordID: bestellingRecordId) { (record, error) in
            
            if let error = error {
                print("\(error)")
            }
            
            DispatchQueue.main.async {
                gotRecord(record)
            }
        }
        
    }
    
    func addBestelling(name: String , completionHandler: @escaping () -> Void){
        
        self.getUserRecorID { (userRecordID) in
            
            self.fetchRecord(record: userRecordID, done: { (userRecord) in
                
                let bestellingRecord = CKRecord(recordType: "Bestelling")
                
                bestellingRecord["name"] = name as CKRecordValue
                
                let reference = CKReference(recordID: userRecordID, action: .deleteSelf)
                bestellingRecord["owner"] = reference as CKRecordValue
                bestellingRecord["persons"] = [reference] as CKRecordValue
                
                self.database.save(bestellingRecord, completionHandler: { (record, error) in
                    if error == nil {

                        var refs: [CKReference]
                        
                        if let reft = userRecord!.object(forKey: "bestSubs"){
                            refs = reft as! [CKReference]
                        } else {
                            refs = [CKReference]()
                        }
                        
                        let newRef = CKReference(record: record!, action: CKReferenceAction.none)
                        
                        refs.append(newRef)
                        
                        userRecord!.setObject(refs as CKRecordValue, forKey: "bestSubs")
                        
                        self.database.save(userRecord!, completionHandler: { (_, error) in
                            
                            if error == nil {
                                completionHandler()
                            }
                            
                        })
                    }
                })
                
            })
            
        }
        
    }
    
    func subscribeTo(BestellingRecord: CKRecord, completionHandler: @escaping (Bool, String) -> Void){
        
        self.getUserRecorID { (userRecordID) in
        
            self.fetchRecord(record: userRecordID, done: { (userRecord) in
                
                if let userRecord = userRecord {
                    
                    var refs = userRecord.object(forKey: "bestSubs") as! [CKReference]
                    
                    for ref in refs {
                        if ref.recordID == BestellingRecord.recordID {
                            completionHandler(false, "Al gesubscribed!")
                            return
                        }
                    }
                    
                    let newRef = CKReference(record: BestellingRecord, action: CKReferenceAction.none)
                    refs.append(newRef)
                    
                    userRecord.setObject(refs as CKRecordValue, forKey: "bestSubs")
                    
                    var persons = BestellingRecord.object(forKey: "persons") as! [CKReference]
                    let newPerson = CKReference(record: userRecord, action: CKReferenceAction.none)
                    persons.append(newPerson)
                    
                    BestellingRecord.setObject(persons as CKRecordValue, forKey: "persons")
                    
                    self.database.save(userRecord, completionHandler: { (_, error) in
                        
                        if error == nil {
                         
                            self.database.save(BestellingRecord, completionHandler: { (_, error) in
                                
                                if error == nil {
                                    
                                    completionHandler(true, "subscribed!")
                                    
                                } else {
                                    completionHandler(false, "BestellingRecord failed!")
                                    
                                }
                                
                                
                                
                            })
                            
                        } else {
                            completionHandler(false, "userRecord failed!")
                        }
                    })
                    
                }
                
            })
        
        }
        
    }
    
    func fetchRecord(record: CKRecordID, done: @escaping (CKRecord?) -> Void){
        
        self.database.fetch(withRecordID: record) { (returnrecord, _) in
            if let returnrecord = returnrecord {
                DispatchQueue.main.async {
                    print("Got Record with RecordID: \(returnrecord)")
                    done(returnrecord)
                }
            } else {
                DispatchQueue.main.async {
                    done(nil)
                }
            }
        }
        
    }
    
    func unsubscribeFrom(BestellingsRecordId: CKRecordID, done: @escaping ()-> Void ) {
        
        self.getUserRecorID { (userRecordID) in
            
            self.fetchRecord(record: userRecordID, done: { (userRecord) in
                
                if let userRecord = userRecord{
                    
                    self.fetchRecord(record: BestellingsRecordId, done: { (record) in
                        
                        if let record = record {
                            
                            var persons = record.object(forKey: "persons") as! [CKReference]
                            let userRef = CKReference(record: userRecord, action: CKReferenceAction.none)
                            
                            let index = persons.index(of: userRef)
                            if let index = index {
                                persons.remove(at: index)
                            }
                            
                            record.setObject(persons as CKRecordValue, forKey: "persons")
                            
                            self.database.save(record, completionHandler: { (record, error) in
                                if error != nil {
                                    print ("Unsubscribe unsucessvol van bestelling")
                                }
                                print ("Unsubscribe sucessvol van bestelling")
                                
                                var bestSubs = userRecord.object(forKey: "bestSubs") as! [CKReference]
                                
                                let bestRef = CKReference(record: record!, action: CKReferenceAction.none)
                                
                                let index = bestSubs.index(of: bestRef)
                                if let index = index {
                                    bestSubs.remove(at: index)
                                }
                                
                                userRecord.setObject(bestSubs as CKRecordValue, forKey: "bestSubs")
                                
                                self.database.save(userRecord, completionHandler: { (_, error) in
                                    if error != nil {
                                        print ("Unsubscribe unsucessvol van eigenLijst")
                                    }
                                    print ("Unsubscribe sucessvol van eigenLijst")
                                    done()
                                })
                                
                            })
                            
                        }
                        
                    })
                    
                    
                    
                }
                
            })
        }
        
    }
    
}
