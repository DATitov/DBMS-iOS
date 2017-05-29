//
//  TablesRelationshipTypeViewViewModel.swift
//  DBMS
//
//  Created by Dmitrii Titov on 19.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class TablesRelationshipTypeViewVM: NSObject {
    
    let disposeBag = DisposeBag()
    
    let side1TableName = Variable<String>("")
    let side1PropertyName = Variable<String>("")
    let side2TableName = Variable<String>("")
    let side2PropertyName = Variable<String>("")
    
    let side1Text = Variable<String>("")
    let side2Text = Variable<String>("")
    
    var relationshipType = TablesRelationshipType.ManyToOne
    
    override init() {
        super.init()
        self.initBindings()
    }
    
    func initBindings() {
        _ = Observable.combineLatest(side1TableName.asObservable(), side1PropertyName.asObservable(), resultSelector: { "\($0).\($1)" })
            .bindTo(self.side1Text)
            .disposed(by: disposeBag)
        
        _ = Observable.combineLatest(side2TableName.asObservable(), side2PropertyName.asObservable(), resultSelector: { "\($0).\($1)" })
            .bindTo(self.side2Text)
            .disposed(by: disposeBag)
    }
    
    func relationshipTypeText(forIndex index: Int) -> String {
        switch index {
        case 0:
            return TablesRelationshipType.ManyToOne.rawValue
        case 1:
            return TablesRelationshipType.OneToOne.rawValue
        case 2:
            return TablesRelationshipType.OneToMany.rawValue
        default:
            return ""
        }
    }
    
    func numberOfRelationshipTypes() -> Int {
        return 3
    }
    
    func didSelectType(atIndex index: Int) {
        switch index {
        case 0:
            relationshipType = .ManyToOne
            break
        case 0:
            relationshipType = .OneToOne
            break
        case 0:
            relationshipType = .OneToMany
            break
        default:
            break
        }
    }
    
}
