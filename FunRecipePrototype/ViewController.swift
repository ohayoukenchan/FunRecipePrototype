//
//  ViewController.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/15.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import UIKit
import RxSwift
import FunRecipeAPI

class ViewController: UIViewController {

    let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var refreshControl: UIRefreshControl = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .init(white: 0.9, alpha: 1.0)
        collectionView.refreshControl = refreshControl

        // Do any additional setup after loading the view.
    }


}

