//
//  UIImageView.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/20.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import UIKit

extension UIImage {
    public convenience init(url: String) {
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            self.init(data: data)!
            return
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        self.init()
    }
}
