//
//  Palettes.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/27.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import Foundation

enum palettes: Int64 {

    case blueColor
    case yellowColor
    case blackColor
    case pinkColor
    case textWhiteColor
    case textGrayColor
    case textDarkGrayColor
    case pinGoldColor
    case pinBlueColor
    case pinPurpleColor
    case pinGoldedColor
    case pinBluedColor
    case pinPurpledColor
    func getColor() -> UIColor {
        switch self {
        case .primaryColor:return UIColor(hex: "#ef2855")
        case .secondaryColor:return UIColor(hex: "#ff7898")
        case .secondaryPinStartColor:return UIColor(hex: "#af0028")
        case .whiteColor:return UIColor(hex: "#ffffff")
        case .grayColor:return UIColor(hex: "#f0f0f0")
        case .darkGrayColor:return UIColor(hex: "#cccccc")
        case .blueColor:return UIColor(hex: "#23abde")
        case .yellowColor:return UIColor(hex: "#ffe100")
        case .blackColor:return UIColor(hex: "#000000")
        case .pinkColor:return UIColor(hex: "#ffecf0")
        case .textWhiteColor:return UIColor(hex: "#ffffff")
        case .textGrayColor:return UIColor(hex: "#666666")
        case .textDarkGrayColor:return UIColor(hex: "#999999")
        case .pinGoldColor:return UIColor(hex: "#CDA92A")
        case .pinBlueColor:return UIColor(hex: "#00ABDB")
        case .pinPurpleColor:return UIColor(hex: "#b38ef1")
        case .pinGoldedColor:return UIColor(hex: "#A28A2C")
        case .pinBluedColor:return UIColor(hex: "#347EA9")
        case .pinPurpledColor:return UIColor(hex: "#735c9c")
        }
    }
}
