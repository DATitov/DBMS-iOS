//
//  NBSimulatorListEditing.swift
//  DBMS
//
//  Created by Dmitrii Titov on 25.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class NBSimulatorListEditing: NavigationBarSimulatorBase {
    
    let disposeBag = DisposeBag()
    
    fileprivate let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus_icon"), for: .normal)
        button.alpha = 0
        return button
    }()
    fileprivate let editingButton = HamburgerButton()
    let isEditing = Variable<Bool>(false)
    
    
    var addButtonPressedAction : (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNBSimulatorListEditingUI()
        self.initNBSimulatorListEditingBingings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNBSimulatorListEditingUI()
        self.initNBSimulatorListEditingBingings()
    }
    
    func setupNBSimulatorListEditingUI() {
        self.addSubview(addButton)
        self.addSubview(editingButton)
        
        addButton.addTarget(self, action: #selector(self.addButtonPressed), for: .touchUpInside)
    }
    
    func setEditing(editing: Bool) {
        editingButton.isSelectedState.value = editing
    }
    
}

extension NBSimulatorListEditing { // MARK: Bindings
    
    func initNBSimulatorListEditingBingings() {
        
        _ = editingButton.isSelectedState.asObservable()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .bindTo(self.isEditing)
            .disposed(by: disposeBag)
        
        _ = isEditing.asObservable()
            .skip(1)
            .subscribeOn(MainScheduler.instance)
            .subscribe { (isEditing) in
                UIView.animate(withDuration: 0.2,
                               animations: {
                                self.layoutSubviews()
                                self.addButton.alpha = isEditing.element! ? 1 : 0
                })
            }
            .disposed(by: disposeBag)
        
    }
    
}

extension NBSimulatorListEditing { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let leadingOffset = 15.0 as CGFloat
        let topOffset = 10.0 as CGFloat
        let heightWithOffset = self.frame.size.height - topOffset
        let backButtonSize = CGSize(width: 50, height: 25)
        let trailingOffset = 15.0 as CGFloat
        let editButtonSize = CGSize(width: 25.0, height: 25.0)
        let plusButtonSize = CGSize(width: 25.0, height: 25.0)
        let betweenButtonsSpace = 20.0 as CGFloat
        let betweenTitleAndButtonsSpace = 10.0 as CGFloat
        let titleLabelSize = { () -> CGSize in
            let height = 30.0 as CGFloat
            let width = min(self.frame.size.width - betweenTitleAndButtonsSpace - plusButtonSize.width -
                betweenButtonsSpace - editButtonSize.width - trailingOffset,
                            self.frame.size.width - (betweenTitleAndButtonsSpace + backButtonSize.width + leadingOffset) * 2)
            return CGSize(width: width,
                          height: height)
        }()
        let backButtonXCoord = isEditing.value ? -backButtonSize.width - leadingOffset : leadingOffset
        let titleXCoord = isEditing.value ? leadingOffset : leadingOffset + backButtonSize.width + betweenTitleAndButtonsSpace
        
        backButton.frame = CGRect(x: backButtonXCoord, y: topOffset + (heightWithOffset - backButtonSize.height) / 2,
                                  width: backButtonSize.width, height: backButtonSize.height)
        titleLabel.frame = CGRect(x: titleXCoord, y: topOffset + (heightWithOffset - titleLabelSize.height) / 2,
                                  width: titleLabelSize.width, height: titleLabelSize.height)
        addButton.frame = CGRect(x: self.frame.size.width - plusButtonSize.width - betweenButtonsSpace - editButtonSize.width - trailingOffset,
                                 y: topOffset + (heightWithOffset - plusButtonSize.height) / 2,
                                 width: plusButtonSize.width, height: plusButtonSize.height)
        editingButton.frame = CGRect(x: self.frame.size.width - editButtonSize.width - trailingOffset, y: topOffset + (heightWithOffset - editButtonSize.height) / 2,
                                     width: editButtonSize.width, height: editButtonSize.height)
    }
    
}

extension NBSimulatorListEditing { // MARK: Actions
    
    @objc func addButtonPressed() {
        if addButtonPressedAction != nil {
            addButtonPressedAction!()
        }
    }
    
}

