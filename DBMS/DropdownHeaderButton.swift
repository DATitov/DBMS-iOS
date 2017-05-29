//
//  DropdownHeaderButton.swift
//  DBMS
//
//  Created by Dmitrii Titov on 23.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DropdownHeaderButton: UIButton {
    
    let disposeBag = DisposeBag()

    let title = Variable<String>("")

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.initBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        self.initBindings()
    }
    
    init() {
        super.init(frame: .zero)
        self.setupUI()
        self.initBindings()
    }
    
    func setupUI() {
        self.setTitleColor(UIColor.black, for: .normal)
    }
    
    func initBindings() {
        
        _ = title.asObservable()
            .bindTo(self.rx.title())
            .disposed(by: disposeBag)
        
    }
    
}
