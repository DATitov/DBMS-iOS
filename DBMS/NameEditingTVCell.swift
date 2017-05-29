//
//  TableNameEditingTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 23.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NameEditingTVCell: BackgroundTVCell {
    
    let disposeBag = DisposeBag()
    
    let infoLabel = UILabel()
    let textField = UITextField()
    let toolBar = UIToolbar()
    
    let isEditingState = Variable<Bool>(true)
    let textIsValid = Variable<Bool>(true)
    let nameTempleText = Variable<String>("")
    let name = Variable<String>("")
    let info = Variable<(message: String, valid: Bool)>(message: "", valid: true)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupTableNameEditingTVCellUI()
        self.initTableNameEditingTVCellBindings()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.setupTableNameEditingTVCellUI()
        self.initTableNameEditingTVCellBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupTableNameEditingTVCellUI()
        self.initTableNameEditingTVCellBindings()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTableNameEditingTVCellUI()
        self.initTableNameEditingTVCellBindings()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: Bindings
    
    func initTableNameEditingTVCellBindings() {
        
        _ = textField.rx.controlEvent([.editingChanged, .editingDidBegin])
            .subscribe(onNext: { [weak self] in
                self?.nameTempleText.value = (self?.textField.text)!
            })
            .addDisposableTo(disposeBag)
        
        _ = info.asObservable()
            .subscribe({ (info) in
                DispatchQueue.main.async { [weak self] in
                    guard self != nil else { return }
                    guard info.element != nil else { return }
                    self!.infoLabel.text = info.element?.message
                    self!.infoLabel.textColor = info.element!.valid ? .white : .red
                    if (self?.toolBar.items?.count)! > 2 {
                        self?.toolBar.items?[2].isEnabled = info.element!.valid
                    }
                }
            })
            .addDisposableTo(disposeBag)
        
        isEditingState.asObservable()
            .subscribe({ (isEditingState) in
                DispatchQueue.main.async { [weak self] in
                    UIView.animate(withDuration: 0.2,
                                   animations: { [weak self] in
                                    self?.setNeedsLayout()
                    })
                    self?.textField.isUserInteractionEnabled = isEditingState.element!
                }
            })
            .addDisposableTo(disposeBag)
        
    }
    
}

extension NameEditingTVCell { // MARK: Setup UI
    
    func setupTableNameEditingTVCellUI() {
        self.setupTableNameEditingTVCellViews()
    }
    
    func setupTableNameEditingTVCellViews() {
        self.setupTableNameEditingTVCellLabels()
        self.setupTableNameEditingTVCellTextFields()
    }
    
    func setupTableNameEditingTVCellLabels() {
        contentView.addSubview(infoLabel)
        infoLabel.textColor = UIColor.yellow
    }
    
    func setupTableNameEditingTVCellTextFields() {
        contentView.addSubview(textField)
        textField.borderStyle = .roundedRect
        textField.placeholder = NSLocalizedString("table_name", comment: "")
        self.setupToolBar()
    }
    
    func setupToolBar() {
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: NSLocalizedString("done", comment: ""), style: UIBarButtonItemStyle.done, target: self, action: #selector(self.donePressed))
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("cancel", comment: ""), style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
    }
    func donePressed() {
        textField.resignFirstResponder()
        name.value = textField.text!
    }
    func cancelPressed() {
        textField.resignFirstResponder()
    }
}

extension NameEditingTVCell { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutViews()
    }
    
    func layoutViews() {
        self.layoutLabels()
        self.layoutTextFields()
    }
    
    func layoutLabels() {
        let horisontalOffset = 15.0 as CGFloat
        let verticalOffset = 5.0 as CGFloat
        let height = self.isEditingState.value ? (self.frame.size.height - verticalOffset * 2) / 2 : 0
        infoLabel.frame = CGRect(x: horisontalOffset, y: self.frame.size.height / 2 - verticalOffset,
                                 width: self.frame.size.width - horisontalOffset * 2, height: height)
    }
    
    func layoutTextFields() {
        let horisontalOffset = 15.0 as CGFloat
        let verticalOffset = 5.0 as CGFloat
        let height = 30.0 as CGFloat
        textField.frame = CGRect(x: horisontalOffset, y: verticalOffset * 2,
                                 width: self.frame.size.width - horisontalOffset * 2, height: height)
    }
    
    static func requiredHeight(short: Bool) -> CGFloat {
        return short ? 50 : 90.0
    }
    
}
