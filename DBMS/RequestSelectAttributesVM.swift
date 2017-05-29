//
//  RequestSelectAttributesViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 22.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class RequestSelectAttributesVM: NSObject {
    
    let disposeBag = DisposeBag()
    
    var dbFramework: DataBaseFramework = .None
    
    let selectedItems = Variable<[RequestSelectionItem]>([RequestSelectionItem]())
    let availableItems = Variable<[RequestSelectionItem]>([RequestSelectionItem]())
    
    let selectedIndexPaths = Variable<[IndexPath]>([IndexPath]())
    
    var selectionAction: (([RequestSelectionItem]) -> ())!
    
    init(dbFramework: DataBaseFramework, selectedItems: [RequestSelectionItem], availableItems: [RequestSelectionItem],
         selectionAction: @escaping (([RequestSelectionItem]) -> ())) {
        super.init()
        self.dbFramework = dbFramework
        self.selectedItems.value = selectedItems
        self.availableItems.value = availableItems
        self.selectionAction = selectionAction
    }
    
    func initBindings() {
        
        
    }
    
    func selectButtonPressed(indexPaths: [IndexPath]) {
        let items = self.generateSelectedItems(indexPaths: indexPaths)
        selectionAction(items)
    }
    
    func generateSelectedItems(indexPaths: [IndexPath]) -> [RequestSelectionItem] {
        var items = [RequestSelectionItem]()
        for row in indexPaths.map({ $0.row }) {
            if row >= availableItems.value.count {
                continue
            }
            items.append(availableItems.value[row])
        }
        return items
    }
    
    func indexPathsForSelectedItems() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for selectedItem in selectedItems.value {
            for (index, availableItem) in availableItems.value.enumerated() {
                if selectedItem.requestName == availableItem.requestName &&
                    selectedItem.attributeName == availableItem.attributeName {
                    indexPaths.append(IndexPath(row: index, section: 0))
                    break
                }
            }
        }
        return indexPaths
    }
    
}
