//
//  RecordEditValueView.swift
//  DBMS
//
//  Created by Dmitrii Titov on 13.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol RecordEditValueViewDelegate: class {
    func returnButtonPressed(sender: RecordEditValueView)
}

class RecordEditValueView: UIView {
    
    weak var delegate: RecordEditValueViewDelegate?
    
    let disposeBag = DisposeBag()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    let valueTextField: UITextField = {
        let txtFld = UITextField()
        txtFld.borderStyle = .roundedRect
        return txtFld
    }()
    let toolBar = UIToolbar()
    
    var tableProperty: TableProperty!
    var value = Variable<String>("")
    
    init(tableProperty: TableProperty, value: String) {
        super.init(frame: .zero)
        self.tableProperty = tableProperty
        self.value.value = value
        self.setupUI()
        self.initBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func textFielsBecomeFirstResponder() {
        valueTextField.becomeFirstResponder()
    }
    
}

extension RecordEditValueView { // MARK: Setup UI
    
    func setupUI() {
        self.setupLabels()
        self.setupTextFields()
        self.setupToolBar()
    }
    
    func setupLabels() {
        nameLabel.text = tableProperty.name
        self.addSubview(nameLabel)
    }
    
    func setupTextFields() {
        valueTextField.placeholder = "Type: " + tableProperty.type.rawValue
        valueTextField.keyboardType = self.keyboardType(forDataType: tableProperty.type)
        valueTextField.text = value.value
        self.addSubview(valueTextField)
        valueTextField.delegate = self
    }
    
    func initBindings() {
        _ = valueTextField.rx.controlEvent([.editingChanged, .editingDidBegin])
            .subscribe(onNext: { [weak self] in
                self?.value.value = (self?.valueTextField.text)!
            })
            .addDisposableTo(disposeBag)
    }
    
    func setupToolBar() {
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.donePressed))
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("cancel", comment: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        valueTextField.inputAccessoryView = toolBar
    }
    
    func donePressed() {
        valueTextField.resignFirstResponder()
        delegate?.returnButtonPressed(sender: self)
    }
    
    func cancelPressed() {
        valueTextField.resignFirstResponder()
    }
}

extension RecordEditValueView { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lWidth = self.frame.size.width * 4 / 11
        let tfwidth = self.frame.size.width * 6 / 11
        let tfHeight = 30.0 as CGFloat
        nameLabel.frame = CGRect(x: 0, y: 0, width: lWidth, height: self.frame.size.height)
        valueTextField.frame = CGRect(x: self.frame.size.width - tfwidth, y: (self.frame.size.height - tfHeight) / 2,
                                      width: tfwidth, height: tfHeight)
    }
    
}

extension RecordEditValueView: UITextFieldDelegate { // MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch tableProperty.type {
        case .String:
            return true
        case .Int64:
            return StringValidator().int(string: textField.text! + string)
        case .Double:
            return StringValidator().float(string: textField.text! + string)
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        valueTextField.resignFirstResponder()
        delegate?.returnButtonPressed(sender: self)
        return true
    }
    
}

extension RecordEditValueView { // MARK: Helpers
    
    fileprivate func keyboardType(forDataType dataType: DataType) -> UIKeyboardType {
        switch dataType {
        case .String:
            return .default
        case .Int64:
            return .phonePad
        case .Double:
            return .numberPad
        default:
            return .default
        }
    }
    
}
