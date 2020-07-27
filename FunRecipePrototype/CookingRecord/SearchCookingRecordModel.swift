//
//  CookingRecordModel.swift
//  FunRecipePrototype
//
//  Created by  ohayoukenchan on 2020/07/21.
//  Copyright © 2020  ohayoukenchan. All rights reserved.
//

import RxSwift
import FunRecipeAPI

protocol SeacrchCookingRecordProtocol {
    func fetchRecord(query: String) -> Observable<[CookingRecord]>
}

final class SearchCookingRecordModel: SeacrchCookingRecordProtocol {

    func fetchRecord(query: String) -> Observable<[CookingRecord]> {
        return Observable.create { [weak self] observer in

            FunRecipeAPI.DefaultAPI.cookingRecordsGet(offset: nil, limit: 50).subscribe(onNext: { result in
                observer.onNext(result.cookingRecords ?? [])
                observer.onCompleted()
            })
        }
    }
}
