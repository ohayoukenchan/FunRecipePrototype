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
    private var searchBar: UISearchBar!

    var computedCellSize: CGSize?

    @IBOutlet weak var collectionView: UICollectionView!

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
        setupViewController()
        setupCollectionView()
        setupViewModel()
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

    private func setupViewController() {
        self.title = "私の料理記録"
    }

    private func setupCollectionView() {
        collectionView.contentInset.top = CookingRecordCell.cellMargin
        collectionView.register(R.nib.cookingRecordCell(), forCellWithReuseIdentifier: R.nib.cookingRecordCell.name)
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.rx.itemSelected
            .map { [weak self] indexPath -> CookingRecordItem? in
                return self?.dataSource[indexPath]
            }
            .subscribe(onNext: { [weak self] item in
                guard let item = item else { return }
                switch item {
                case .record(let record):
                    print(record)
                }
            })
            .disposed(by: disposeBag)
    }

    private func setupViewModel() {
        let fetcher = SearchCookingRecordModel()
        viewModel = CookingRecordViewModel(searchModel: fetcher)
        viewModel.items
            .asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        fetcher.fetchRecord(query: "aaa").subscribe(onNext: { result in
            self.viewModel.updateItems(cookingRecords: result)
        })

    }

    private func cookingRecordCell(indexPath: IndexPath, record: CookingRecord) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.cookingRecordCell.name, for: indexPath) as? CookingRecordCell {
            cell.update(comment: record.comment ?? "", imageUrl: record.imageUrl ?? "")
            return cell
        }
        return UICollectionViewCell()
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
