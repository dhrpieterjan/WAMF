//
//  BestellingTableViewCell.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 03/11/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import UIKit

class BestellingTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var aantalSubsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
