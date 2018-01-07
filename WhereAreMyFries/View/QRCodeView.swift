//
//  QRCodeView.swift
//  WhereAreMyFries
//
//  Created by Pieter-Jan Philips on 01/01/2018.
//  Copyright © 2018 Pieter-Jan Philips. All rights reserved.
//

import UIKit

class QRCodeView: UIView {

    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("QRCodeView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
    
}
