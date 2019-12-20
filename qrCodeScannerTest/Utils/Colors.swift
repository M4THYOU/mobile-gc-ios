//
//  Colors.swift
//  qrCodeScannerTest
//
//  Created by Matthew Wolfe on 2019-12-16.
//  Copyright © 2019 Matthew Wolfe. All rights reserved.
//

import UIKit

// Converts the given r, g, and b values into a UIColor.
func rgb(r: Float, g: Float, b: Float) -> UIColor {
    let red: CGFloat = CGFloat(r/255)
    let green: CGFloat = CGFloat(g/255)
    let blue: CGFloat = CGFloat(b/255)
    return UIColor.init(red: red, green: green, blue: blue, alpha: 1)
}

struct Colors {
    
    static let warningRed = rgb(r: 179, g: 58, b: 58) // hex: #b33a3a
    
    static let almostWhite = rgb(r: 248, g: 248, b: 248) // hex: #fafafa
    static let almostWhiteDarker = rgb(r: 235, g: 235, b: 235) // hex: #ebebeb
    
    static let quakedLightBlue = rgb(r: 0, g: 162, b: 255) // hex: #00a2ff
    static let quakedDarkBlue = rgb(r: 101, g: 100, b: 219) // hex: #6564db
    
}
