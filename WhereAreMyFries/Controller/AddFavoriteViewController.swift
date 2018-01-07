//
//  AddFavoriteViewController.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 07/01/2018.
//  Copyright © 2018 Pieter-Jan Philips. All rights reserved.
//

import UIKit

class AddFavoriteViewController: UIViewController {

    @IBOutlet weak var OpmerkingenTextField: UITextView!
    @IBOutlet weak var CollectionPicker: UIPickerView!
    @IBOutlet weak var nametextfield: UITextField!
    
    @IBOutlet weak var savaButton: UIButton!
    var snacks: [Snack] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savaButton.isEnabled = false
        self.view.layer.backgroundColor = UIColor.clear.cgColor
        OpmerkingenTextField.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        OpmerkingenTextField.text = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Save(_ sender: UIButton) {
        
        sender.isEnabled = false
        addButton()
        
    }
    
    @objc func addButton() {
        BestellingenRepository().saveFavForPerson(snacks: snacks, opmerking: self.OpmerkingenTextField.text!, naam: nametextfield.text!) {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "addNewFavorite", sender: nil)
            }
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    
    
}

extension AddFavoriteViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}

extension AddFavoriteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let oldText = text as NSString
            let newText = oldText.replacingCharacters(in: range, with: string)
            savaButton.isEnabled = newText.count > 0
        } else {
            savaButton.isEnabled = string.count > 0
        }
        return true
    }
}

extension AddFavoriteViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return snacks.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return snacks[row].naam
    }
    
}
