//
//  SnackRepository.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 14/11/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import UIKit
import CloudKit

class ScackRepository {
    
    var database = CKContainer.default().publicCloudDatabase
    var snacks = [Snack]()
    var snackdict: [String: [Snack]] = ["Snack":[], "Dranken": [], "Sauzen": [], "Frieten": [], "Burgers": []]
    
    var query = CKQuery(recordType: "Snack", predicate: NSPredicate(value: true))
    
    func getAllSnacks(completionHandler: @escaping ([String: [Snack]]) -> Void ){
        
        database.perform(query, inZoneWith: nil) { (records, _) in
            
            if let records = records {
                
                for record in records {
                    
                    let cat = record.object(forKey: "categorie") as! String
                    
                    let newSnack = Snack(
                        naam: record.object(forKey: "naam") as! String,
                        image: record.object(forKey: "image") as! String,
                        categorie: record.object(forKey: "categorie") as! String,
                        recordId: record.recordID)
                    
                    self.snackdict[cat]?.append(newSnack)
                    
                    self.snacks.append(Snack(
                        naam: record.object(forKey: "naam") as! String,
                        image: record.object(forKey: "image") as! String,
                        categorie: record.object(forKey: "categorie") as! String,
                        recordId: record.recordID))
                }
                
            }
            
            DispatchQueue.main.async {
                print("got all snacks")
                //print("\(self.snackdict)")
                completionHandler(self.snackdict)
            }
            
        }
        
    }
    
    func initialiseData() {
        
        
        
        let snacks: [String: [String]] = [ "Snack": [ "Lange lummel", "Bitterballen", "Kippenboutjes", "Taco", "Kipkorn", "Vleeskroket",              "Lucifer","Kinderbox", "Mozarella sticks", "Ribster", "Bamischijf", "Ragouzi", "Berehap", "Vicking", "Vuurvreter", "Loempia", "Platte boulet", "Kalkoenstick", "Mexicano", "Spicy viandel", "Kleie sate", "Grote sate", "Mini loempias", "Kaaskroket", "Zigeunerstick", "Visbrochette", "Chicken nuggets", "Kipvingers", "Frikandel", "Frikandel special", "Viandel", "Reuzemix" ],
                                           "Dranken" : ["Cola", "Cola Zero", "Cola Light", "Fanta", "Sprite", "Plat water", "Bruis water", "Ice-Tea", "Jupiler", "Wijn rood", "Wijn wit", "Koffie", "thee"],
                                           "Sauzen": ["Mayonaise", "Frietsaus", "Tartaar", "Americain", "Andalouse", "Bicky saus", "Curry", "Cocktail", "Joppie", "Mammoet", "Brazilsaus", "Looksaus", "Loempiasaus", "Mosterd", "Pepersaus", "Pickels", "Samurai", "Pili Pili", "Huisgemaakte tartaar", "Stoofvleessous", "Stoofvlees", "Balletjes in tomatensaus", "Vol-au-vent"],
                                           "Frieten": ["Mini friet", "Kleine friet", "Middel friet", "Grote friet", "Reuze friet"],
                                           "Burgers": ["Bicky Burger", "Bicky Wrap", "Bicky cheese", "Bicky chicken"]]
        
        for (key, values) in snacks {
            
            for val in values {
                
                let snackrecord = CKRecord(recordType: "Snack")
                snackrecord.setObject(val as CKRecordValue, forKey: "naam")
                let imagenaam = val.replacingOccurrences(of: " ", with: "")
                snackrecord.setObject(imagenaam as CKRecordValue, forKey: "image")
                snackrecord.setObject(key as CKRecordValue, forKey: "categorie")
                
                database.save(snackrecord) { (_, error) in
                    print(error)
                }
                
            }

        }
        
    }
    
}
