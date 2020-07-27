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

class CookingRecordViewModel {
    let items = BehaviorRelay<[CookingRecordSectionModel]>(value: [])
    let fetcher: SearchCookingRecordModel
    var keyword: String = ""

    private var disposeBag = DisposeBag()

    init(searchModel: SearchCookingRecordModel, searchBar: Driver<String>) {
        fetcher = searchModel
        searchBar.drive(onNext: { [unowned self] text in
            print("text: \(text)")
            self.keyword = text
            self.setupItems(self.keyword)
        }).disposed(by: disposeBag)
        self.setupItems()
    }

    func setupItems(_ query: String = "") {
        var records: [CookingRecord] = []
        fetcher.fetchRecord(query: query).subscribe(onNext: { result in
            if query.isEmpty {
                records = result
            } else {
                records = result.filter { ($0.comment?.contains(query) ?? false) }
            }
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
