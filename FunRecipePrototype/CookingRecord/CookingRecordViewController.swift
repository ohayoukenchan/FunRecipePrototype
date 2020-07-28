//
//  CookingRecordViewController.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/16.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import Foundation
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
    private var mainDishButton: UIButton! = UIButton()
    private var sideDishButton: UIButton! = UIButton()
    private var soupButton: UIButton! = UIButton()

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
        setupCategoryLabel()
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
        viewModel = CookingRecordViewModel()
        viewModel.inputs.isMainButtonTapped.accept(false)
        viewModel.inputs.isSideDishButtonTapped.accept(false)
        viewModel.inputs.isSoupButtonTapped.accept(false)

        searchBar.rx.text
            .bind(to: viewModel.inputs.searchText)
            .disposed(by: disposeBag)

        viewModel.outputs.items
            .asDriver()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        mainDishButton.rx.tap.asSignal()
            .withLatestFrom(viewModel.outputs.isMainButtonActive)
            .emit(onNext: { [weak self] isTapped in
                self?.viewModel.inputs.isSideDishButtonTapped.accept(false)
                self?.viewModel.inputs.isSoupButtonTapped.accept(false)
                self?.viewModel.inputs.isMainButtonTapped.accept(!isTapped)
                self?.viewModel.inputs.selectedType.accept(RecipeTypes.main_dish)
            })
            .disposed(by: disposeBag)

        sideDishButton.rx.tap.asSignal()
            .withLatestFrom(viewModel.outputs.isSideDishButtonActive)
            .emit(onNext: { [weak self] isTapped in
                self?.viewModel.inputs.isMainButtonTapped.accept(false)
                self?.viewModel.inputs.isSoupButtonTapped.accept(false)
                self?.viewModel.inputs.isSideDishButtonTapped.accept(!isTapped)
                self?.viewModel.inputs.selectedType.accept(RecipeTypes.side_dish)
            })
            .disposed(by: disposeBag)

        soupButton.rx.tap.asSignal()
            .withLatestFrom(viewModel.outputs.isSoupButtonActive)
            .emit(onNext: { [weak self] isTapped in
                self?.viewModel.inputs.isMainButtonTapped.accept(false)
                self?.viewModel.inputs.isSideDishButtonTapped.accept(false)
                self?.viewModel.inputs.isSoupButtonTapped.accept(!isTapped)
                self?.viewModel.inputs.selectedType.accept(RecipeTypes.soup)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.isMainButtonActive
            .drive(onNext: { [weak self] isActive in
                guard let button = self?.mainDishButton else {
                    return
                }
                self?.changeButtonUIByState(button: button, flag: isActive)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.isSideDishButtonActive
            .drive(onNext: { [weak self] isActive in
                guard let button = self?.sideDishButton else {
                    return
                }
                self?.changeButtonUIByState(button: button, flag: isActive)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.isSoupButtonActive
            .drive(onNext: { [weak self] isActive in
                guard let button = self?.soupButton else {
                    return
                }
                self?.changeButtonUIByState(button: button, flag: isActive)
            })
            .disposed(by: disposeBag)
    }

    private func changeButtonUIByState(button:UIButton, flag: Bool) {
        if flag {
            button.layer.backgroundColor = Palettes.blueColor.getColor().cgColor
            button.setTitleColor(Palettes.textWhiteColor.getColor(), for: UIControl.State.normal)
        } else {
            button.layer.backgroundColor = Palettes.grayColor.getColor().cgColor
            button.setTitleColor(Palettes.textDarkGrayColor.getColor(), for: UIControl.State.normal)
        }
    }

    private func cookingRecordCell(indexPath: IndexPath, record: CookingRecord) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.cookingRecordCell.name, for: indexPath) as? CookingRecordCell {
            cell.update(comment: record.comment ?? "", imageUrl: record.imageUrl ?? "")
            return cell
        }
        return UICollectionViewCell()
    }

    private func setupCategoryLabel() {

        let tabLabelWidth:CGFloat = 60
        let tabLabelHeight:CGFloat = categoryCollectionView.frame.height - 10
        var originX:CGFloat = 4

        for recipeType in RecipeTypes.allCases {
            let button: UIButton
            switch recipeType {
            case .main_dish:
                button = mainDishButton
            case .side_dish:
                button = sideDishButton
            case .soup:
                button = soupButton
            }
            button.setTitle(recipeType.description, for: .normal)
            button.setTitleColor(Palettes.textDarkGrayColor.getColor(), for: UIControl.State.normal)
            button.layer.backgroundColor = Palettes.grayColor.getColor().cgColor
            button.frame = CGRect(x:originX, y:8, width:tabLabelWidth, height:tabLabelHeight)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
            button.titleEdgeInsets = UIEdgeInsets(top: 2.0, left: 7.0, bottom: 2.0, right: 7.0)
            button.layer.cornerRadius = 10

            categoryCollectionView.addSubview(button)

            originX += tabLabelWidth + 10
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


