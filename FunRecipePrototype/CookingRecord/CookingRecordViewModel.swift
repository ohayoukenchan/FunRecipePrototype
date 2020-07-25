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

    init(searchModel: SearchCookingRecordModel) {
        fetcher = searchModel
        setupItems()
    }

    func setupItems() {
        fetcher.fetchRecord(query: "aaa").subscribe(onNext: { result in
            self.updateItems(cookingRecords: result)
        })
    }

    func updateItems(cookingRecords: [CookingRecord]) {
        var sections: [CookingRecordSectionModel] = []

        let cookingRecordItems = cookingRecords.map { CookingRecordItem.record(record: $0) }
        let cookingRecordSection = CookingRecordSectionModel(model: .record, items: cookingRecordItems)
        sections.append(cookingRecordSection)
        
        items.accept(sections)
    }
}
