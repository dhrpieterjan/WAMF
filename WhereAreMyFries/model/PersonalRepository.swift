//
//  PersonalRepository.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 07/01/2018.
//  Copyright © 2018 Pieter-Jan Philips. All rights reserved.
//

import Foundation
import CloudKit

class PersonalRepository {
    
    func getUserName(completionHandler: @escaping (String) -> Void) {
        
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                // error handling magic
                return
            }
            
            CKContainer.default().requestApplicationPermission(.userDiscoverability) { status, error in
                guard status == .granted, error == nil else {
                    // error handling voodoo
                    return
                }
                
                CKContainer.default().discoverUserIdentity(withUserRecordID: recordID) { identity, error in
                    guard let components = identity?.nameComponents, error == nil else {
                        // more error handling magic
                        return
                    }
                    let fullName = PersonNameComponentsFormatter().string(from: components)
                    completionHandler(fullName)
                    
                }
                
            }
            
        }
        
    }
    
}
