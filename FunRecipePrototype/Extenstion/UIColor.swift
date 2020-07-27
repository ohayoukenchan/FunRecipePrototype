//
//  UIColor.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/27.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import Foundation
import UIKit

// UIColor を16進数で指定可能にする
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let value = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: value as String)
        var color: UInt32 = 0
        if scanner.scanHexInt32(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16) / 255.0
            let g = CGFloat((color & 0x00FF00) >> 8) / 255.0
            let b = CGFloat(color & 0x0000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: alpha)
        } else {
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
        }
    }
}
