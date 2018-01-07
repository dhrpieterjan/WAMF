//
//  SnackCollectionViewCell.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 09/11/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import UIKit

class SnackCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var snackNameLabel: UILabel!
    
    var snack: Snack! {
        didSet {
            snackNameLabel.text = snack.naam
        }
    }
    
    private func prepareView() {
        enable(bool: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareView()
    }
    
    func enable(bool: Bool){
        if bool {
            //snackNameLabel.textColor = UIColor.black
            self.layer.cornerRadius = 2.0
            self.contentView.layer.borderWidth = 1.0
            self.contentView.layer.borderColor = UIColor.clear.cgColor
            self.contentView.layer.masksToBounds = true
            self.layer.backgroundColor = UIColor.white.cgColor
            
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowOffset = CGSize(width: -5, height: 5)
            self.layer.shadowRadius = 2.0
            self.layer.shadowOpacity = 1.0
            self.layer.masksToBounds = false
        } else {
            //snackNameLabel.textColor = UIColor.white
            self.layer.cornerRadius = 2.0
            self.layer.backgroundColor = UIColor.clear.cgColor
            self.contentView.layer.masksToBounds = true
            
            self.layer.shadowColor = UIColor.clear.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 0
            self.layer.shadowOpacity = 0
            self.layer.masksToBounds = false
        }
    }

}
