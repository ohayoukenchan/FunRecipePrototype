//
//  CookingRecordCell.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/21.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import Foundation
import UIKit

class PropotionalSizingCell: UICollectionViewCell, PrototypeViewSizing {

}

class CookingRecordCell: UICollectionViewCell, PrototypeViewSizing {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var commentLabel: UILabel!

    static let cellMargin: CGFloat = 8.0

    func update(comment: String, imageUrl: String) {
        print(comment)
        commentLabel.text = comment
        imageView.image = UIImage(url: imageUrl)
    }
}
