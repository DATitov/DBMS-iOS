//
//  TablesRelationshipTypeView.swift
//  DBMS
//
//  Created by Dmitrii Titov on 19.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TablesRelationshipTypeView: UIView {
    
    let disposeBag = DisposeBag()
    
    let side1Label = UILabel()
    let side2Label: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    let pickerView = UIPickerView()
    
    var viewModel: TablesRelationshipTypeViewVM!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    func bindViewModel(viewModel: TablesRelationshipTypeViewVM) {
        self.viewModel = viewModel
        
        _ = viewModel.side1Text.asObservable()
            .bindTo(self.side1Label.rx.text)
            .disposed(by: disposeBag)
        
        _ = viewModel.side2Text.asObservable()
            .bindTo(self.side2Label.rx.text)
            .disposed(by: disposeBag)
    }
    
    func setupUI() {
        self.addSubview(side1Label)
        self.addSubview(side2Label)
        self.addSubview(pickerView)
        
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
}

extension TablesRelationshipTypeView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let view = UIView(frame: pickerView.bounds)
        let label = UILabel(frame: pickerView.bounds)
        label.textAlignment = .center
        label.text = viewModel.relationshipTypeText(forIndex: row)
        label.font = UIFont.systemFont(ofSize: 15)
        label.adjustsFontSizeToFitWidth = true
        view.addSubview(label)
        
        return view
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.didSelectType(atIndex: row)
    }
    
}

extension TablesRelationshipTypeView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfRelationshipTypes()
    }
    
}

extension TablesRelationshipTypeView { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horisontalOffset = 15.0 as CGFloat
        let verticalOffset = 5.0 as CGFloat
        let height = self.frame.size.height - 2 * verticalOffset
        let labelWidth = (self.frame.size.width - horisontalOffset * 2) * 2 / 7
        let pickerViewWidth = (self.frame.size.width - horisontalOffset * 2) * 3 / 7
        
        side1Label.frame = CGRect(x: horisontalOffset, y: verticalOffset,
                                  width: labelWidth, height: height)
        side2Label.frame = CGRect(x: self.frame.size.width - labelWidth - horisontalOffset, y: verticalOffset,
                                  width: labelWidth, height: height)
        pickerView.frame = CGRect(x: horisontalOffset + labelWidth, y: verticalOffset,
                                  width: pickerViewWidth, height: height)
    }
    
}
