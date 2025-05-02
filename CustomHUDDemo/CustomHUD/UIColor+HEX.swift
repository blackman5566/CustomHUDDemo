//
//  UIColor.swift
//  CosmedApp
//
//  Created by Mac on 2017/4/5.
//  Copyright © 2017年 Ufispace. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rx: Int, gx: Int, bx: Int) {
        assert(rx >= 0 && rx <= 255, "Invalid red component")
        assert(gx >= 0 && gx <= 255, "Invalid green component")
        assert(bx >= 0 && bx <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(rx) / 255.0, green: CGFloat(gx) / 255.0, blue: CGFloat(bx) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red: CGFloat((netHex & 0xFF0000) >> 16), green: CGFloat((netHex & 0x00FF00) >> 8), blue: CGFloat(netHex & 0x0000FF))
    }
    
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
