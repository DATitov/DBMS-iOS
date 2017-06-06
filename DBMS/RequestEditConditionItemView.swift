//
//  RequestEditConditionItemView.swift
//  DBMS
//
//  Created by Dmitrii Titov on 23.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift
import DTAlertViewContainer

class RequestEditConditionItemView: UIView {
    
    let disposeBag = DisposeBag()
    
    let selectionItemDropdown = DropdownView()
    let typePiclerView = UIPickerView()
    let valueTextField = UITextField()
    let backgroundView = RequestEditConditionItemBackgroundView()
    let valueTitleLabel = UILabel()
    
    let cancelButton = AlertViewButton()
    let saveButton = AlertViewButton()
    
    var viewModel: RequestEditConditionItemVM!
    
    weak var delegate: DTAlertViewDelegate?
    var requiredHeight = 0.0 as CGFloat
    var frameToFocus = CGRect.zero
    var needToFocus = false
    
    //weak var delegate: AlertViewDelegate?
    
    init(viewModel: RequestEditConditionItemVM) {
        super.init(frame: CGRect.zero)
        self.bindViewModel(viewModel: viewModel)
        self.setupUI()
        self.initBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        self.initBindings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.initBindings()
    }
    
    func setupUI() {
        self.setupBackground()
        self.setupDropdown()
        self.setupPickerView()
        self.setupTextField()
        self.setupButtons()
        self.setupLabels()
    }
    
    func setupBackground() {
        self.addSubview(backgroundView)
    }
    
    func setupDropdown() {
        self.addSubview(selectionItemDropdown)
        selectionItemDropdown.tableView.register(TwoLabelTVCell.self, forCellReuseIdentifier: "TwoLabelTVCell")
    }
    
    func setupPickerView() {
        self.addSubview(typePiclerView)
        typePiclerView.delegate = self
        typePiclerView.dataSource = self
    }
    
    func setupTextField() {
        self.addSubview(valueTextField)
        valueTextField.borderStyle = .roundedRect
        valueTextField.delegate = self
    }
    
    func setupLabels() {
        self.addSubview(valueTitleLabel)
        valueTitleLabel.text = "Value:"
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
    
    func bindViewModel(viewModel: RequestEditConditionItemVM) {
        self.viewModel = viewModel
        
        valueTextField.text = viewModel.conditionItem.value.value
        
        viewModel.availableSelectionItems.asObservable()
            .bindTo(self.selectionItemDropdown.tableView.rx.items(cellIdentifier: "TwoLabelTVCell", cellType: TwoLabelTVCell.self)) { (row, model, cell) in
                cell.update(text1: model.requestName, text2: model.attributeName)
            }
            .disposed(by: viewModel.disposeBag)
        
        _ = viewModel.conditionItem.asObservable()
            .map({ (item) -> String in
                guard let requestName = item.selectedItem?.requestName, let attributeName = item.selectedItem?.attributeName else {
                    return NSLocalizedString("select_the_attribute", comment: "")
                }
                if requestName.characters.count * attributeName.characters.count == 0 {
                    return NSLocalizedString("select_the_attribute", comment: "")
                }
                return requestName + "." + attributeName
            })
            .bindTo(selectionItemDropdown.title)
            .disposed(by: viewModel.disposeBag)
        
        _ = Observable.combineLatest(selectionItemDropdown.selectedIndex.asObservable(),
                                     viewModel.availableSelectionItems.asObservable(),
                                     resultSelector: { (index, selectionItems) -> RequestSelectionItem in
                                        if index >= selectionItems.count {
                                            return RequestSelectionItem()
                                        }
                                        return selectionItems[index]
        })
            .skip(1)
            .subscribe(onNext: { (selectionItem) in
                self.viewModel.pushSelectionItem(selectionItem: selectionItem)
            })
            .disposed(by: viewModel.disposeBag)
        
    }
    
    func initBindings() {
        
        _ = selectionItemDropdown.requiredHeight.asObservable()
            .map({ [unowned self] _ -> CGFloat in
                return self.calculateRequiredHeight()
            })
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] (requiredHeight) in
                self.requiredHeight = requiredHeight
                self.delegate?.layoutAlertView(animated: true)
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.6,
                               initialSpringVelocity: 0.2,
                               options: [],
                               animations: {
                                self.layoutSubviews()
                },
                               completion: nil)
            })
            .disposed(by: disposeBag)
        
        _ = selectionItemDropdown.state.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (state) in
                if state != DropdownViewState.Unselected {
                    self.valueTextField.resignFirstResponder()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
}

extension RequestEditConditionItemView: DTAlertViewProtocol {
    
    func backgroundPressed() {
        
    }
    
}

extension RequestEditConditionItemView: UIPickerViewDelegate { // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch row {
        case 0:
            return RequestConditionType.Less.rawValue
        case 1:
            return RequestConditionType.Equal.rawValue
        case 2:
            return RequestConditionType.More.rawValue
        default:
            return ""
        }
    }
    
}

extension RequestEditConditionItemView: UIPickerViewDataSource { // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if selectionItemDropdown.state.value != DropdownViewState.Unselected {
            selectionItemDropdown.state.value = DropdownViewState.Unselected
        }
        
        let type = { () -> RequestConditionType in
            switch row {
            case 0:
                return RequestConditionType.Less
            case 1:
                return RequestConditionType.Equal
            case 2:
                return RequestConditionType.More
            default:
                return RequestConditionType.Equal
            }
        }()
        viewModel.pushConditionType(type: type)
    }
    
}

extension RequestEditConditionItemView: UITextFieldDelegate { // MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if selectionItemDropdown.state.value != DropdownViewState.Unselected {
            selectionItemDropdown.state.value = DropdownViewState.Unselected
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        viewModel.pushVale(value: textField.text ?? "")
        return true
    }
    
}

extension RequestEditConditionItemView { // MARK: Layout
    
    func verticalSpaces() -> (topSpace: CGFloat, dropdownHeight: CGFloat, betweenDropdownAndPickerViewSpace: CGFloat, pickerViewHeight: CGFloat, betweenPickerViewAndTexeFieldSpace: CGFloat, textFieldHeight: CGFloat, betweenTextFieldAndButtonsSpace: CGFloat, buttonsHeight: CGFloat, bottomSpace: CGFloat) {
        let dropdownHeight = selectionItemDropdown.requiredHeight.value
        return (topSpace: 15,
                dropdownHeight: dropdownHeight,
                betweenDropdownAndPickerViewSpace: 15,
                pickerViewHeight: 80,
                betweenPickerViewAndTexeFieldSpace: 15,
                textFieldHeight: 32,
                betweenTextFieldAndButtonsSpace: 20,
                buttonsHeight: 30,
                bottomSpace: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let verticalSpaces = self.verticalSpaces()
        
        let betweenTextFieldAndButtonsSpace = verticalSpaces.betweenTextFieldAndButtonsSpace
        let betweenPickerViewAndTexeFieldSpace = verticalSpaces.betweenPickerViewAndTexeFieldSpace
        let textFieldHeight = verticalSpaces.textFieldHeight
        let betweenDropdownAndPickerViewSpace = verticalSpaces.betweenDropdownAndPickerViewSpace
        let pickerViewHeight = verticalSpaces.pickerViewHeight
        let dropdownHeight = verticalSpaces.dropdownHeight
        let topSpace = verticalSpaces.topSpace
        let horisontalOffset = 15.0 as CGFloat
        let width = self.frame.size.width - horisontalOffset * 2
        let buttonsSize = CGSize(width: self.frame.size.width * 2 / 5, height: verticalSpaces.buttonsHeight)
        let labelwidth = 50.0 as CGFloat
        
        backgroundView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width,
                                      height: self.calculateRequiredHeight() - betweenTextFieldAndButtonsSpace / 2 - buttonsSize.height - verticalSpaces.bottomSpace)
        
        selectionItemDropdown.frame = CGRect(x: horisontalOffset, y: topSpace,
                                             width: width, height: dropdownHeight)
        typePiclerView.frame = CGRect(x: horisontalOffset, y: topSpace + dropdownHeight + betweenDropdownAndPickerViewSpace,
                                      width: width, height: pickerViewHeight)
        valueTitleLabel.frame = CGRect(x: horisontalOffset, y: topSpace + dropdownHeight + betweenDropdownAndPickerViewSpace + pickerViewHeight + betweenPickerViewAndTexeFieldSpace,
                                       width: labelwidth, height: textFieldHeight)
        valueTextField.frame = CGRect(x: horisontalOffset + labelwidth, y: topSpace + dropdownHeight + betweenDropdownAndPickerViewSpace + pickerViewHeight + betweenPickerViewAndTexeFieldSpace,
                                      width: width - labelwidth, height: textFieldHeight)
        
        let buttonsYCoord = topSpace + dropdownHeight + betweenDropdownAndPickerViewSpace + pickerViewHeight + betweenPickerViewAndTexeFieldSpace + textFieldHeight + betweenTextFieldAndButtonsSpace
        let buttonsHorisontalOffset = horisontalOffset + 4.0
        cancelButton.frame = CGRect(x: buttonsHorisontalOffset, y: buttonsYCoord,
                                    width: buttonsSize.width, height: buttonsSize.height)
        saveButton.frame = CGRect(x: self.frame.size.width - buttonsSize.width - buttonsHorisontalOffset, y: buttonsYCoord,
                                  width: buttonsSize.width, height: buttonsSize.height)
    }
    
    fileprivate func calculateRequiredHeight() -> CGFloat {
        let verticalSpaces = self.verticalSpaces()
        return verticalSpaces.topSpace + verticalSpaces.dropdownHeight + verticalSpaces.betweenDropdownAndPickerViewSpace +
            verticalSpaces.pickerViewHeight + verticalSpaces.betweenPickerViewAndTexeFieldSpace + verticalSpaces.textFieldHeight +
            verticalSpaces.betweenTextFieldAndButtonsSpace + verticalSpaces.buttonsHeight + verticalSpaces.bottomSpace
    }
    
}

extension RequestEditConditionItemView { // MARK: Actions
    
    @objc func cancelButtonPressed() {
        if selectionItemDropdown.state.value != DropdownViewState.Unselected {
            selectionItemDropdown.state.value = DropdownViewState.Unselected
        }
        valueTextField.resignFirstResponder()
        delegate?.dismiss()
    }
    
    @objc func saveButtonPressed() {
        //delegate?.saveButtonPressed(object: relationship)
    }
}
