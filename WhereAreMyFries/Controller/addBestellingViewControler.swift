//
//  addBestellingViewControler.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 03/11/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import UIKit
import CloudKit
import AVFoundation

class addBestellingViewController: UIViewController {
    
    var bestelling : Bestelling?
    var database : CKDatabase?
    var userRecordID: CKRecordID?
    var bestellingen: [Bestelling]?
    var bestellingenRecords: [CKRecord]?
    var bestellingRecord: CKRecord?
    var alert: UIAlertController?
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        let myContainer = CKContainer.default()
        database = myContainer.publicCloudDatabase
        saveButton.isEnabled = false
        
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                // error handling magic
                return
            }
            self.userRecordID = recordID
            print(recordID)
        }
        
        
        
    }
    
    @IBAction func unwindFromScanQRCode(_ segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func hideKeyboard(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    
    @IBAction func addBestelling(_ sender: UIBarButtonItem) {
        
        sender.isEnabled = false
        addButton()
        
    }
    
    @objc func addButton() {
       
        let indicatorView = UIActivityIndicatorView()
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        indicatorView.color = UIColor.black
        
        let barloaderItem = UIBarButtonItem(customView: indicatorView)
        //navbarLoadingBtns.append(barloaderItem)
        self.navigationItem.setRightBarButtonItems([barloaderItem], animated: true)
        nameLabel.isEnabled = false
        
        BestellingenRepository().addBestelling(name: nameLabel.text!) {
            DispatchQueue.main.async {
                //self.navigationItem.setRightBarButtonItems(self.navbarLoadingBtns, animated: true)
                self.performSegue(withIdentifier: "addBestellingSuccess", sender: Any?.self)
            }
        }

    }
    
}

extension addBestellingViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let oldText = text as NSString
            let newText = oldText.replacingCharacters(in: range, with: string)
            saveButton.isEnabled = newText.count > 0
        } else {
            saveButton.isEnabled = string.count > 0
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Done --->")
        return true
    }
}

