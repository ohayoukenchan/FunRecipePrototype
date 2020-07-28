//
//  CookingRecordViewModel.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/16.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//
import RxSwift
import RxCocoa
import RxDataSources
import FunRecipeAPI

typealias CookingRecordSectionModel = SectionModel<CookingRecordSection, CookingRecordItem>

enum CookingRecordSection {
    case record
}

enum CookingRecordItem {
    case record(record: CookingRecord)
}

protocol CookingRecordViewModelInputs: AnyObject {
    var isMainButtonTapped: PublishRelay<Bool> { get }
    var isSideDishButtonTapped: PublishRelay<Bool> { get }
    var isSoupButtonTapped: PublishRelay<Bool> { get }
    var searchText: AnyObserver<String?> { get }
    var selectedType: PublishRelay<RecipeTypes> { get }
}

protocol CookingRecordViewModelOutputs: AnyObject {
    var isMainButtonActive: Driver<Bool> { get }
    var isSideDishButtonActive: Driver<Bool> { get }
    var isSoupButtonActive: Driver<Bool> { get }
    var items: BehaviorRelay<[CookingRecordSectionModel]> { get }
}

protocol CookingRecordViewModelType: AnyObject {
    var inputs: CookingRecordViewModelInputs { get }
    var outputs: CookingRecordViewModelOutputs { get }
}

class CookingRecordViewModel: CookingRecordViewModelType, CookingRecordViewModelInputs, CookingRecordViewModelOutputs {

    var searchText: AnyObserver<String?>

    var inputs: CookingRecordViewModelInputs { return self }
    var outputs: CookingRecordViewModelOutputs { return self }

    // MARK: - Input
    let isMainButtonTapped = PublishRelay<Bool>()
    let isSideDishButtonTapped = PublishRelay<Bool>()
    let isSoupButtonTapped = PublishRelay<Bool>()
    let selectedType = PublishRelay<RecipeTypes>()

    // MARK: - Output
    let items = BehaviorRelay<[CookingRecordSectionModel]>(value: [])
    let isMainButtonActive: Driver<Bool>
    let isSideDishButtonActive: Driver<Bool>
    let isSoupButtonActive: Driver<Bool>

    let fetcher = SearchCookingRecordModel()

    private var disposeBag = DisposeBag()

    init() {

        isMainButtonActive = isMainButtonTapped.asDriver(onErrorDriveWith: .empty())
        isSideDishButtonActive = isSideDishButtonTapped.asDriver(onErrorDriveWith: .empty())
        isSoupButtonActive = isSoupButtonTapped.asDriver(onErrorDriveWith: .empty())

        _ = isMainButtonActive.asDriver().drive()
        _ = isSideDishButtonActive.asDriver().drive()
        _ = isSoupButtonActive.asDriver().drive()

        let _searchText = PublishRelay<String?>()
        self.searchText = AnyObserver<String?>() { event in
            guard let text = event.element else {
                return
            }
            _searchText.accept(text)
        }

        Observable.combineLatest(
                selectedType.asObservable(),
                _searchText
            )
            .subscribe(onNext: {
                let type = $0.0.value
                var query = ""
                if let q = $0.1 {
                    query = q
                }
                self.fetchItems(query: query, type: type)
            }).disposed(by: disposeBag)

        self.fetchItems()
    }

    func fetchItems(query: String = "", type: String = "") {
        var records: [CookingRecord] = []
        fetcher.fetchRecord(query: query).subscribe(onNext: { result in
            records = result

            if !type.isEmpty {
                records = records.filter { ($0.recipeType?.contains(type) ?? false) }
            }
            if !query.isEmpty {
                records = records.filter { ($0.comment?.contains(query) ?? false) }
            }
            print(query)

            self.updateItems(cookingRecords: records)
        }).disposed(by: disposeBag)
    }

    func updateItems(cookingRecords: [CookingRecord]) {
        var sections: [CookingRecordSectionModel] = []

        let cookingRecordItems = cookingRecords.map { CookingRecordItem.record(record: $0) }
        let cookingRecordSection = CookingRecordSectionModel(model: .record, items: cookingRecordItems)
        sections.append(cookingRecordSection)
        
        items.accept(sections)
    }
}
