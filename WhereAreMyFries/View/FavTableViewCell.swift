//
//  FavTableViewCell.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 07/01/2018.
//  Copyright © 2018 Pieter-Jan Philips. All rights reserved.
//

import UIKit

class FavTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var detailLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
