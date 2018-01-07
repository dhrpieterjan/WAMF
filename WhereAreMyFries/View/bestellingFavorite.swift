//
//  bestellingFavorite.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 07/01/2018.
//  Copyright © 2018 Pieter-Jan Philips. All rights reserved.
//

import UIKit

class bestellingFavorite: UITableViewCell {

    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var bestellingText: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
