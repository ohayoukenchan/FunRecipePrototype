//
//  Palettes.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/27.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import Foundation
import UIKit

enum Palettes: Int64 {

    case grayColor
    case darkGrayColor
    case blackColor
    case pinkColor
    case textWhiteColor
    case textGrayColor
    case textDarkGrayColor
    case blueColor
    case yellowColor

    func getColor() -> UIColor {
        switch self {
        case .grayColor:return UIColor(hex: "#f0f0f0")
        case .darkGrayColor:return UIColor(hex: "#cccccc")
        case .blueColor:return UIColor(hex: "#23abde")
        case .yellowColor:return UIColor(hex: "#ffe100")
        case .blackColor:return UIColor(hex: "#000000")
        case .pinkColor:return UIColor(hex: "#ffecf0")
        case .textWhiteColor:return UIColor(hex: "#ffffff")
        case .textGrayColor:return UIColor(hex: "#666666")
        case .textDarkGrayColor:return UIColor(hex: "#999999")
        }
    }
}
