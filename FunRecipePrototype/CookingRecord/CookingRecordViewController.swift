//
//  CookingRecordViewController.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/16.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import FunRecipeAPI

class CookingRecordViewController: UIViewController, UISearchBarDelegate {

    private var tableView: UITableView!

    var computedCellSize: CGSize?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!

    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<CookingRecordSectionModel>(configureCell: configureCell)

    private lazy var configureCell: RxCollectionViewSectionedReloadDataSource<CookingRecordSectionModel>.ConfigureCell = { [weak self] (_, tableView, indexPath, item) in
        guard let strongSelf = self else { return UICollectionViewCell() }
        switch item {
        case .record(let record):
            return strongSelf.cookingRecordCell(indexPath: indexPath, record: record)
        }
    }

    private var disposeBag = DisposeBag()

    private var viewModel: CookingRecordViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupCategoryLabel()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension CookingRecordViewController {

    private func setupCollectionView() {
        collectionView.contentInset.top = CookingRecordCell.cellMargin
        collectionView.register(R.nib.cookingRecordCell(), forCellWithReuseIdentifier: R.nib.cookingRecordCell.name)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.rx.itemSelected
            .map { [weak self] indexPath -> CookingRecordItem? in
                return self?.dataSource[indexPath]
        }
        .subscribe(onNext: { item in
            guard let item = item else { return }
            switch item {
            case .record(let record):
                print(record)
            }
        }).disposed(by: disposeBag)
    }

    private func setupViewModel() {
        let fetcher = SearchCookingRecordModel()
        viewModel = CookingRecordViewModel(
            searchModel: fetcher,
            searchBar: searchBar.rx.text.orEmpty.asDriver()
        )
        viewModel.items
            .asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }

    private func cookingRecordCell(indexPath: IndexPath, record: CookingRecord) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.cookingRecordCell.name, for: indexPath) as? CookingRecordCell {
            cell.update(comment: record.comment ?? "", imageUrl: record.imageUrl ?? "")
            return cell
        }
        return UICollectionViewCell()
    }

    private func setupCategoryLabel() {
        let titles = ["メイン","スープ"]
        let tabLabelWidth:CGFloat = 100
        let tabLabelHeight:CGFloat = categoryCollectionView.frame.height
        var originX:CGFloat = 0
        for title in titles {
            let button = UIButton()
            button.setTitle(title, for: .normal) // ボタンのタイトル
            button.setTitleColor(UIColor.black, for: .normal) // タイトルの色
            //button.textAlignment = .center
            button.frame = CGRect(x:originX, y:0, width:tabLabelWidth, height:tabLabelHeight)
            button.titleLabel?.text = title

            categoryCollectionView.addSubview(button)

            originX += tabLabelWidth
        }

        categoryCollectionView.contentSize = CGSize(width:originX, height:tabLabelHeight)
    }
}

extension CookingRecordViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cellSize = self.computedCellSize {
            return cellSize
        } else {
            guard
                let prototypeCell = R.nib.cookingRecordCell.instantiate(withOwner: nil, options: nil).first as? CookingRecordCell,
                let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
                else {
                    fatalError()
            }

            let cellSize = prototypeCell.propotionalScaledSize(for: flowLayout, numberOfColumns: 3)
            self.computedCellSize = cellSize

            return cellSize
        }
    }
}
