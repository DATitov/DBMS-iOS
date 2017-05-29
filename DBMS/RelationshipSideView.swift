//
//  RelationshipSideView.swift
//  DBMS
//
//  Created by Dmitrii Titov on 18.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class RelationshipSideView: UIView {
    
    let disposeBag = DisposeBag()
    
    let tableLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("table", comment: "") + ":"
        return label
    }()
    let propertyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("attribute", comment: "") + ":"
        return label
    }()
    
    let tablePickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.tag = 0
        return pickerView
    }()
    let propertyPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.tag = 1
        return pickerView
    }()
    
    let backgroundView = RelationshipSideBackgroundView()
    
    var viewModel: RelationshipSideVM!
    
    init(viewModel: RelationshipSideVM) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    func bindViewModel(viewModel: RelationshipSideVM) {
        self.viewModel = viewModel
        
        _ = viewModel.availableTables.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (_) in
                self.tablePickerView.reloadAllComponents()
            })
            .disposed(by: disposeBag)
        
        _ = viewModel.availableProperties.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (_) in
                self.propertyPickerView.reloadAllComponents()
            })
            .disposed(by: disposeBag)
    }
    
    func setupUI() {
        self.addSubview(backgroundView)
        self.addSubview(tableLabel)
        self.addSubview(propertyLabel)
        self.addSubview(tablePickerView)
        self.addSubview(propertyPickerView)
        
        for pickerView in [tablePickerView, propertyPickerView] {
            pickerView.delegate = self
            pickerView.dataSource = self
        }
    }
    
}

extension RelationshipSideView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return viewModel.tableName(forIndex: row)
        }else{
            return viewModel.tablePropertyName(forIndex: row)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            viewModel.didSelectTable(atIndex: row)
        }else{
            viewModel.didSelectProprty(atIndex: row)
        }
    }
    
}

extension RelationshipSideView: UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return viewModel.availableTables.value.count
        }else{
            return viewModel.availableProperties.value.count
        }
    }
    
}

extension RelationshipSideView { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundView.frame = self.bounds
        
        let horisontalOffset = 20.0 as CGFloat
        let verticalOffset = 15.0 as CGFloat
        let labelSize = CGSize(width: 80, height: 22)
        let pickerSize = CGSize(width: self.frame.size.width - labelSize.width - horisontalOffset * 2,
                                height: (self.frame.size.height - 2 * verticalOffset) / 2)
        
        tableLabel.frame = CGRect(x: horisontalOffset, y: verticalOffset + (pickerSize.height - labelSize.height) / 2,
                                  width: labelSize.width, height: labelSize.height)
        propertyLabel.frame = CGRect(x: horisontalOffset, y: verticalOffset + (pickerSize.height - labelSize.height) / 2 + pickerSize.height,
                                  width: labelSize.width, height: labelSize.height)
        tablePickerView.frame = CGRect(x: horisontalOffset + labelSize.width + 2, y: verticalOffset, width: pickerSize.width, height: pickerSize.height)
        propertyPickerView.frame = CGRect(x: horisontalOffset + labelSize.width + 2, y: verticalOffset + pickerSize.height, width: pickerSize.width, height: pickerSize.height)
    }
    
    static func requiredHeight() -> CGFloat {
        return 170.0
    }
    
}
