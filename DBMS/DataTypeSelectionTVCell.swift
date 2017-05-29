//
//  DataTypeSwitcherTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 04.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import pop
import RxSwift
import RxCocoa

class DataTypeSelectionTVCell: UITableViewCell {
    
    var viewModel: DataTypeSelectionCellVM?
    
    let disposeBag = DisposeBag()
    
    let valueText = Variable<String>("")
    let isEditingState = Variable<Bool>(false)
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initBindings()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initBindings() {
        _ = isEditingState.asObservable()
            .distinctUntilChanged()
            .subscribe(onNext: { (isEditingState) in
                DispatchQueue.main.async { [weak self] in
                    if isEditingState {
                        self?.runEditingStateAnimation()
                    }else{
                        self?.runNormalStateAnimation()
                    }
                }
            })
            .addDisposableTo(disposeBag)
        
    }
    
}

extension DataTypeSelectionTVCell {
    
    func setupUI() {
        self.setupViews()
    }
    
    func setupViews() {
        self.setupLabels()
        self.setupPickerView()
    }
    
    func setupLabels() {
        
    }
    
    func setupPickerView() {
        pickerView.selectRow((viewModel?.index(dataType: (viewModel?.dataTypeVariable.value)!))!, inComponent: 0, animated: false)
    }
    
}

extension DataTypeSelectionTVCell: UIPickerViewDelegate { // MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel?.dataTypeString(index: row)
    }
    
}

extension DataTypeSelectionTVCell: UIPickerViewDataSource { // MARK: UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (viewModel?.dataTypesCount())!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        valueLabel.text = pickerView.delegate?.pickerView!(pickerView, titleForRow: row, forComponent: component)
    }
    
}

extension DataTypeSelectionTVCell {
    // MARK: Animations
    
    private func animationDuration() -> CGFloat {
        return 0.2 as CGFloat
    }
    
    func runEditingStateAnimation() {
        let pickerViewAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        let valueLabelAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        for animation in [pickerViewAnimation, valueLabelAnimation] {
            animation?.duration = CFTimeInterval(self.animationDuration())
        }
        
        pickerViewAnimation?.toValue = 1.0
        valueLabelAnimation?.toValue = 0.0
        
        valueLabel.pop_add(valueLabelAnimation, forKey: "valueLabelAnimationHide")
        pickerView.pop_add(pickerViewAnimation, forKey: "pickerViewAnimationShow")
    }
    
    func runNormalStateAnimation() {
        let pickerViewAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        let valueLabelAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        for animation in [pickerViewAnimation, valueLabelAnimation] {
            animation?.duration = CFTimeInterval(self.animationDuration())
        }
        
        pickerViewAnimation?.toValue = 0.0
        valueLabelAnimation?.toValue = 1.0
        
        pickerView.pop_add(pickerViewAnimation, forKey: "pickerViewAnimationHide")
        valueLabel.pop_add(valueLabelAnimation, forKey: "valueLabelAnimationShow")
    }
    
}
