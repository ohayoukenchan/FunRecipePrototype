//
//  CookingRecordCell.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/21.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class PropotionalSizingCell: UICollectionViewCell, PrototypeViewSizing {

}

class CookingRecordCell: UICollectionViewCell, PrototypeViewSizing {
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var commentLabel: UILabel!



    static let cellMargin: CGFloat = 8.0

    func update(comment: String, imageUrl: String) {
        commentLabel.text = comment
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: imageUrl),
                              // キャッシュがある場合はキャッシュを使用する
                              completionHandler: {
                                (image, error, cacheType, imageURL) in
                                self.imageView.image = image
        })


        // 角を丸くする
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
    }
}
