//
//  SnackSectionHeaderCollectionReusableView.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 31/12/2017.
//  Copyright © 2017 Pieter-Jan Philips. All rights reserved.
//

import UIKit

class SnackSectionHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var sectionNameLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

