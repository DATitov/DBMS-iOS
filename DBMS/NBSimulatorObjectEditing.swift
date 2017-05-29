//
//  NBSimulatorObjectEditing.swift
//  DBMS
//
//  Created by Dmitrii Titov on 25.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift
import pop

class NBSimulatorObjectEditing: NavigationBarSimulatorBase {
    
    let disposeBag = DisposeBag()
    
    fileprivate let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "plus_icon"), for: .normal)
        button.alpha = 0
        return button
    }()
    fileprivate let removeButton: SaveButton = {
        let button = SaveButton()
        button.setTitle(NSLocalizedString("remove", comment: ""), for: .normal)
        button.alpha = 0
        button.layer.borderColor = UIColor.red.cgColor
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    fileprivate let editingButton = HamburgerButton()
    let titleTextField: UITextField = {
        let textField = UITextField()
        textField.alpha = 0
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        return textField
    }()
    let infoLabel = UILabel()
    let toolBar = UIToolbar()
    
    let isEditing = Variable<Bool>(false)
    let textIsValid = Variable<Bool>(true)
    let nameTempleText = Variable<String>("")
    let name = Variable<String>("")
    let info = Variable<(message: String, valid: Bool)>(message: "", valid: true)
    
    var addButtonPressedAction : (() -> ())?
    var removeButtonPressedAction : (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNBSimulatorObjectEditingUI()
        self.initNBSimulatorObjectEditingBingings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNBSimulatorObjectEditingUI()
        self.initNBSimulatorObjectEditingBingings()
    }
    
    func setupNBSimulatorObjectEditingUI() {
        self.addSubview(addButton)
        self.addSubview(removeButton)
        self.addSubview(editingButton)
        self.addSubview(titleTextField)
        self.addSubview(infoLabel)
        
        addButton.addTarget(self, action: #selector(self.addButtonPressed), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(self.removeButtonPressed), for: .touchUpInside)
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
        
        titleTextField.inputAccessoryView = toolBar
    }
    func donePressed() {
        titleTextField.resignFirstResponder()
        name.value = titleTextField.text!
    }
    func cancelPressed() {
        titleTextField.resignFirstResponder()
    }
    
    func setEditing(editing: Bool) {
        editingButton.isSelectedState.value = editing
    }
    
    func initNBSimulatorObjectEditingBingings() {
        
        _ = editingButton.isSelectedState.asObservable()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .bindTo(self.isEditing)
            .disposed(by: disposeBag)
        
        _ = isEditing.asObservable()
            .skip(1)
            .subscribeOn(MainScheduler.instance)
            .subscribe { [weak self] (isEditing) in
                let duration = 0.2
                guard let weakSelf = self else { return }
                UIView.animate(withDuration: duration / 3,
                               delay: isEditing.element! ? duration * 2 / 3 : 0,
                               options: [],
                               animations: {
                                weakSelf.removeButton.alpha = isEditing.element! ? 1 : 0
                                weakSelf.infoLabel.alpha = isEditing.element! ? 1 : 0
                },
                               completion: nil)
                UIView.animate(withDuration: duration,
                               animations: {
                                weakSelf.layoutViews()
                                weakSelf.addButton.alpha = isEditing.element! ? 1 : 0
                                weakSelf.titleTextField.alpha = isEditing.element! ? 1 : 0
                                weakSelf.titleLabel.alpha = isEditing.element! ? 0 : 1
                })
            }
            .disposed(by: disposeBag)
        
        
        _ = titleTextField.rx.controlEvent([.editingChanged, .editingDidBegin])
            .subscribe(onNext: { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.nameTempleText.value = (weakSelf.titleTextField.text)!
            })
            .addDisposableTo(disposeBag)
        
        _ = info.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe({ [weak self] (info) in
                guard let weakSelf = self else { return }
                guard info.element != nil else { return }
                weakSelf.infoLabel.text = info.element?.message
                weakSelf.infoLabel.textColor = info.element!.valid ? .white : .red
                if (weakSelf.toolBar.items?.count)! > 2 {
                    weakSelf.toolBar.items?[2].isEnabled = info.element!.valid
                }
            })
            .addDisposableTo(disposeBag)
        
        _ = name.asObservable()
            .bindTo(self.titleLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
    
}

extension NBSimulatorObjectEditing: UITextFieldDelegate { // MARK: UITextFieldDelegate
    
}

extension NBSimulatorObjectEditing { // MARK: Layout
    
    func layoutViews() {
        let leadingOffset = 15.0 as CGFloat
        let topOffset = 10.0 as CGFloat
        let line1Height = 44.0 as CGFloat
        let line2Height = 34.0 as CGFloat
        let backButtonSize = CGSize(width: 50, height: 25)
        let trailingOffset = 15.0 as CGFloat
        let editButtonSize = CGSize(width: 25.0, height: 25.0)
        let plusButtonSize = CGSize(width: 25.0, height: 25.0)
        let betweenButtonsSpace = 20.0 as CGFloat
        let betweenTitleAndButtonsSpace = 10.0 as CGFloat
        let removeButtonSize = CGSize(width: plusButtonSize.width + betweenButtonsSpace + editButtonSize.width, height: 25)
        let titleLabelSize = { () -> CGSize in
            let height = 30.0 as CGFloat
            let width = min(self.frame.size.width - betweenTitleAndButtonsSpace - plusButtonSize.width -
                betweenButtonsSpace - editButtonSize.width - trailingOffset,
                            self.frame.size.width - (betweenTitleAndButtonsSpace + backButtonSize.width + leadingOffset) * 2)
            return CGSize(width: width,
                          height: height)
        }()
        let infoLabelSize = CGSize(width: self.frame.size.width - betweenTitleAndButtonsSpace - leadingOffset - trailingOffset - removeButtonSize.width,
                                   height: 30)
        let backButtonXCoord = isEditing.value ? -backButtonSize.width - leadingOffset : leadingOffset
        let titleXCoord = isEditing.value ? leadingOffset : leadingOffset + backButtonSize.width + betweenTitleAndButtonsSpace
        
        backButton.frame = CGRect(x: backButtonXCoord, y: topOffset + (line1Height - backButtonSize.height) / 2,
                                  width: backButtonSize.width, height: backButtonSize.height)
        titleLabel.frame = CGRect(x: titleXCoord, y: topOffset + (line1Height - titleLabelSize.height) / 2,
                                  width: titleLabelSize.width, height: titleLabelSize.height)
        titleTextField.frame = CGRect(x: titleXCoord, y: topOffset + (line1Height - titleLabelSize.height) / 2,
                                      width: titleLabelSize.width, height: titleLabelSize.height)
        addButton.frame = CGRect(x: self.frame.size.width - plusButtonSize.width - betweenButtonsSpace - editButtonSize.width - trailingOffset,
                                 y: topOffset + (line1Height - plusButtonSize.height) / 2,
                                 width: plusButtonSize.width, height: plusButtonSize.height)
        editingButton.frame = CGRect(x: self.frame.size.width - editButtonSize.width - trailingOffset, y: topOffset + (line1Height - editButtonSize.height) / 2,
                                     width: editButtonSize.width, height: editButtonSize.height)
        removeButton.frame = CGRect(x: self.frame.size.width - plusButtonSize.width - betweenButtonsSpace - editButtonSize.width - trailingOffset,
                                    y: topOffset + line1Height + (line2Height - removeButtonSize.height) / 2 - 5,
                                    width: removeButtonSize.width, height: removeButtonSize.height)
        infoLabel.frame = CGRect(x: leadingOffset, y: topOffset + line1Height + (line2Height - infoLabelSize.height) / 2,
                                 width: infoLabelSize.width, height: infoLabelSize.height)
        backgroundLayerView.frame =  CGRect(x: 0, y: -backgroundLayerView.layer.cornerRadius,
                                            width: self.frame.size.width, height: isEditing.value ? 98 : 54  + backgroundLayerView.layer.cornerRadius)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutViews()
    }
    
}

extension NBSimulatorObjectEditing { // MARK: Actions
    
    @objc func addButtonPressed() {
        if addButtonPressedAction != nil {
            addButtonPressedAction!()
        }
    }
    
    @objc func removeButtonPressed() {
        if removeButtonPressedAction != nil {
            removeButtonPressedAction!()
        }
    }
    
}
