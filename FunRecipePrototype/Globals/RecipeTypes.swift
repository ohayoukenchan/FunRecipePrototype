//
//  RecipeTypes.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/27.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum RecipeTypes {
    case main_dish
    case side_dish
    case soup
}

extension RecipeTypes: CustomStringConvertible {
    var description: String {
        switch self {
        case .main_dish:
            return "メイン"
        case .side_dish:
            return "サイド"
        case .soup:
            return "スープ"
        }
    }
}

extension RecipeTypes {
    var textColor: UIColor {
        switch self {
        case .main_dish:
            return Palettes.blueColor.getColor()
        case .side_dish:
            return Palettes.grayColor.getColor()
        case .soup:
            return Palettes.grayColor.getColor()
        }
    }
}

extension Reactive where Base: UILabel {
    var button: Binder<RecipeTypes> {
        return Binder(base) { label, result in
            label.textColor = result.textColor
            label.text = result.description
        }
    }
}