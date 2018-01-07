//
//  BestellingenTableViewCell.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 10/11/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import UIKit

class BestellingenTableViewCell: UITableViewCell {

    @IBOutlet weak var aantalSubsLabel: UILabel!
    @IBOutlet weak var naamLabel: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.backgroundColor = UIColor(red:0.93, green:0.95, blue:0.95, alpha:1.0).cgColor
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

