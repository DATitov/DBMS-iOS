//
//  RecordView.swift
//  DBMS
//
//  Created by Dmitrii Titov on 13.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AlertViewDelegate: class {
    func cancelButtonPressed()
    func saveButtonPressed(object: AnyObject)
}

class RecordView: UIView {
    
    let disposeBag = DisposeBag()
    var propertiesValuesDisposeBag = DisposeBag()
    
    let propertiesViews = Variable<[RecordEditValueView]>([RecordEditValueView]())

    weak var delegate: AlertViewDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let cancelButton = AlertViewButton()
    let saveButton = AlertViewButton()
    let backgroundView = UIView()
    
    let backgroundViewContentLayer: CALayer = {
        let layer = CALayer()
        layer.cornerRadius = 3
        return layer
    }()
    var separatorsViews = [UIView]()
    
    var tableData: TableData!
    var record: Record?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initBindings()
    }
    
    func update(withTableData tableData: TableData, andRecord record: Record?) {
        self.removeUI()
        self.tableData = tableData
        self.record = record
        self.setupUI()
    }
    
    func initBindings() {
        _ = propertiesViews.asObservable()
            .map({ (propertiesViews) -> [Observable<String>] in
                return propertiesViews.map({ $0.value.asObservable() })
            })
            .subscribe(onNext: { [unowned self] (elems) in
                self.propertiesValuesDisposeBag = DisposeBag()
                Observable.combineLatest(elems, { (strings) -> Bool in
                    return strings.filter({ $0.characters.count < 1 }).count == 0
                })
                    .bindTo(self.saveButton.rx.isEnabled)
                    .disposed(by: self.propertiesValuesDisposeBag)
            })
            .disposed(by: self.disposeBag)
    }
    
}

extension RecordView { // MARK: Setup UI
    
    func setupUI() {
        self.setupBackgroundView()
        self.setupLabels()
        self.setupTablePropertiesViews()
        self.setupButtons()
        self.setupSeparators()
        
        self.configureView()
    }
    
    func configureView() {
        backgroundColor = UIColor.clear
    }
    
    func removeUI() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }
    
    func setupButtons() {
        cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        saveButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        for button in [cancelButton, saveButton] {
            self.addSubview(button)
        }
        cancelButton.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(self.saveButtonPressed), for: .touchUpInside)
    }
    
    func setupSeparators() {
        separatorsViews = [UIView]()
        if tableData.properties.count == 0 {
            return
        }
        for _ in 0..<tableData.properties.count - 1 {
            let separator = UIView()
            separator.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            self.addSubview(separator)
            separatorsViews.append(separator)
        }
    }
    
    func setupBackgroundView() {
        backgroundView.layer.addSublayer(backgroundViewContentLayer)
        backgroundView.backgroundColor = UIColor.clear
        backgroundViewContentLayer.borderColor = UIColor.black.cgColor
        backgroundViewContentLayer.backgroundColor = CommonCollorsStorage.cellBackgroundColor().cgColor
        backgroundViewContentLayer.borderWidth = 1
        self.addSubview(backgroundView)
    }
    
    func setupLabels() {
        self.addSubview(titleLabel)
        titleLabel.text = tableData.name
    }
    
    func setupTablePropertiesViews() {
        propertiesViews.value = [RecordEditValueView]()
        for (index, property) in tableData.properties.enumerated() {
            guard let value = record == nil ? "" : record?.valuesDict[property.name] else {
                continue
            }
            let propertyView = RecordEditValueView(tableProperty: property, value: value)
            propertyView.tag = index
            propertyView.delegate = self
            self.addSubview(propertyView)
            propertiesViews.value.append(propertyView)
        }
    }
    
}

extension RecordView: RecordEditValueViewDelegate { // MARK: RecordEditValueViewDelegate
    
    func returnButtonPressed(sender: RecordEditValueView) {
        if sender.tag < propertiesViews.value.count - 1 {
            propertiesViews.value[sender.tag + 1].textFielsBecomeFirstResponder()
        }
    }
    
}

extension RecordView { // MARK: Layout
    
    fileprivate func verticalSpaces() -> (topOffset: CGFloat, labelHeight: CGFloat, betweenTitleAndProperties: CGFloat, propertyViewHeight: CGFloat, betweenPropertiesSpace: CGFloat, bottomSpace: CGFloat, betweenPropertiesAndButtonsSpace: CGFloat, buttonsHeight: CGFloat) {
        return (topOffset: 10.0,
                labelHeight: 20,
                betweenTitleAndProperties: 13.0,
                propertyViewHeight: 31.0,
                betweenPropertiesSpace: 5.0,
                bottomSpace: 10,
                betweenPropertiesAndButtonsSpace: 30,
                buttonsHeight: 30)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutBackgroundView()
        self.layoutSeparators()
        
        let verticalSpaces = self.verticalSpaces()
        
        let topOffset = verticalSpaces.topOffset
        let labelSize = CGSize(width: 100, height: verticalSpaces.labelHeight)
        let betweenTitleAndPropertiesSpace = verticalSpaces.betweenTitleAndProperties
        let betweenPropertiesSpace = verticalSpaces.betweenPropertiesSpace
        let propertiesTopOffset = labelSize.height + topOffset + betweenTitleAndPropertiesSpace
        let propertiesHorisontalOffset = 15.0 as CGFloat
        let propertiesSize = CGSize(width: self.frame.size.width - propertiesHorisontalOffset * 2, height: verticalSpaces.propertyViewHeight)
        
        titleLabel.frame = CGRect(x: (self.frame.size.width - labelSize.width) / 2, y: topOffset,
                                  width: labelSize.width, height: labelSize.height)
        for (index, propertyView) in propertiesViews.value.enumerated() {
            let yCoord = propertiesTopOffset + (propertiesSize.height + betweenPropertiesSpace) * CGFloat(index)
            propertyView.frame = CGRect(x: propertiesHorisontalOffset, y: yCoord,
                                        width: propertiesSize.width, height: propertiesSize.height)
        }
        
        let buttonsSize = CGSize(width: self.frame.size.width * 2 / 5, height: verticalSpaces.buttonsHeight)
        let buttonsYCoord: CGFloat = {
            if propertiesViews.value.count > 0 {
                return (propertiesViews.value.last?.frame.maxY)! + verticalSpaces.betweenPropertiesAndButtonsSpace
            }else{
                return verticalSpaces.topOffset + verticalSpaces.labelHeight + verticalSpaces.betweenPropertiesAndButtonsSpace
            }
        }()
        let buttonsHorisontalOffset = propertiesHorisontalOffset + 4.0
        cancelButton.frame = CGRect(x: buttonsHorisontalOffset, y: buttonsYCoord,
                                    width: buttonsSize.width, height: buttonsSize.height)
        saveButton.frame = CGRect(x: self.frame.size.width - buttonsSize.width - buttonsHorisontalOffset, y: buttonsYCoord,
                                    width: buttonsSize.width, height: buttonsSize.height)
    }
    
    func layoutSeparators() {
        let verticalSpaces = self.verticalSpaces()
        for (index, separator) in separatorsViews.enumerated() {
            guard propertiesViews.value.count - 1 > index else {
                continue
            }
            let yCoord = propertiesViews.value[index].frame.maxY + verticalSpaces.betweenPropertiesSpace / 2 - 0.5
            let leadingOffset = 30.0 as CGFloat
            let trailingOffset = 170.0 as CGFloat
            separator.frame = CGRect(x: leadingOffset, y: yCoord,
                                     width: self.frame.size.width - leadingOffset - trailingOffset, height: 1)
        }
    }
    
    func layoutBackgroundView() {
        backgroundView.frame = self.bounds
        let verticalSpaces = self.verticalSpaces()
        let height: CGFloat = {
            var propertiesHeight = 0.0 as CGFloat
            if propertiesViews.value.count > 0 {
                propertiesHeight = (propertiesViews.value.last?.frame.maxY)! + verticalSpaces.betweenPropertiesAndButtonsSpace
            }else{
                propertiesHeight = verticalSpaces.topOffset + verticalSpaces.labelHeight + verticalSpaces.betweenPropertiesAndButtonsSpace
            }
            return propertiesHeight - verticalSpaces.betweenPropertiesAndButtonsSpace / 2
        }()
        backgroundViewContentLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width,
                                                  height: height)
    }
    
    func requiredHeight() -> CGFloat {
        let verticalSpaces = self.verticalSpaces()
        let labelArea = verticalSpaces.topOffset + verticalSpaces.labelHeight + verticalSpaces.betweenTitleAndProperties
        let propertiesHeight = propertiesViews.value.reduce(0.0) {
            (accumulation: CGFloat, _) -> CGFloat in
            return accumulation + verticalSpaces.betweenPropertiesSpace + verticalSpaces.propertyViewHeight
        } - verticalSpaces.betweenPropertiesSpace
        let requiredHeight = labelArea + propertiesHeight + verticalSpaces.betweenPropertiesAndButtonsSpace + verticalSpaces.buttonsHeight + verticalSpaces.bottomSpace
        return requiredHeight
    }
    
}

extension RecordView { // MARK: Actions
    
    @objc func cancelButtonPressed() {
        delegate?.cancelButtonPressed()
    }
    
    @objc func saveButtonPressed() {
        let newRecord = self.constructRecord()
        record = newRecord
        self.update(withTableData: tableData, andRecord: record)
        delegate?.saveButtonPressed(object: newRecord)
    }
    
    func constructRecord() -> Record {
        let newRecord = Record(tableData: tableData)
        guard tableData.properties.count == propertiesViews.value.count else {
            return Record()
        }
        for (propertyName, value) in zip(tableData.properties.map({ $0.name}), propertiesViews.value.map({ $0.value.value })) {
            newRecord.valuesDict[propertyName] = value
        }
        return newRecord
    }
    
}


