//
//  PrototypeViewSizing.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/16.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import UIKit

protocol PrototypeViewSizing: class {
}

extension PrototypeViewSizing where Self: UICollectionViewCell {
    func propotionalScaledSize(
        for flowLayout: UICollectionViewFlowLayout,
        numberOfColumns nColumns: Int
    ) -> CGSize {
        let width = flowLayout.preferredItemWidth(forNumberOfColumns: nColumns)
        self.bounds.size = CGSize(width: width, height: 0)
        self.layoutIfNeeded()
        
        return self.systemLayoutSizeFitting(
            UIView.layoutFittingExpandedSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        )
    }

    func horizontalScaledSize(for flowLayout: UICollectionViewFlowLayout) -> CGSize {
        return self.propotionalScaledSize(for: flowLayout, numberOfColumns: 1)
    }
}

private extension UICollectionViewFlowLayout {
    func preferredItemWidth(forNumberOfColumns nColumns: Int) -> CGFloat {
        guard nColumns > 0 else {
            return 0
        }
        guard let collectionView = self.collectionView else {
            fatalError()
        }
        
        let collectionViewWidth = collectionView.bounds.width
        let inset = self.sectionInset
        let spacing = self.minimumInteritemSpacing
        
        return (collectionViewWidth - (inset.left + inset.right + spacing * CGFloat(nColumns - 1))) / CGFloat(nColumns)
    }
}
