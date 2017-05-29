//
//  RequestEditConditionItemViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 23.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class RequestEditConditionItemVM: NSObject {
    
    let disposeBag = DisposeBag()
    
    var dbFramework: DataBaseFramework = .None
    
    var conditionItem = Variable<RequestConditionItem>(RequestConditionItem())
    let availableSelectionItems = Variable<[RequestSelectionItem]>([RequestSelectionItem]())
    
    init(dbFramework: DataBaseFramework, conditionItem: RequestConditionItem, availableSelectionItems: [RequestSelectionItem]) {
        super.init()
        self.dbFramework = dbFramework
        self.conditionItem.value = conditionItem
        self.availableSelectionItems.value = availableSelectionItems
    }
    
    func pushSelectionItem(selectionItem: RequestSelectionItem) {
        DataManagerAPI.shared.conditionUpdateSelectionItem(conditionItem: conditionItem.value, selectedItem: selectionItem)
        conditionItem.value = conditionItem.value
    }
    
    func pushConditionType(type: RequestConditionType) {
        DataManagerAPI.shared.conditionUpdateType(conditionItem: conditionItem.value, typeString: type.rawValue)
        conditionItem.value = conditionItem.value
    }
    
    func pushVale(value: String) {
        DataManagerAPI.shared.conditionUpdateValue(conditionItem: conditionItem.value, valueString: value)
        conditionItem.value = conditionItem.value
    }
    
}
