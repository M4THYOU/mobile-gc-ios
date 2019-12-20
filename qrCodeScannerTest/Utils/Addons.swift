//
//  Addons.swift
//  qrCodeScannerTest
//
//  Created by Matthew Wolfe on 2019-12-16.
//  Copyright © 2019 Matthew Wolfe. All rights reserved.
//

import UIKit

class LeftPaddedTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
}

class ErrorLabel: UILabel {
    
    /******************************/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textColor = Colors.warningRed
        font = UIFont.systemFont(ofSize: 11, weight: UIFont.Weight(rawValue: 0.2))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /******************************/
    
}
