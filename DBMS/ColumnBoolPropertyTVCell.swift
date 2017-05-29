//
//  ColumnBoolPropertyTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 03.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift
import pop

class ColumnBoolPropertyTVCell: UITableViewCell {
    
    
    let disposeBag = DisposeBag()
    
    let valueText = Variable<String>("")
    let isEditingState = Variable<Bool>(false)
    let userSwitchValue = Variable<Bool>(false)
    
    @IBOutlet weak var propertyTitleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
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
        
        _ = switcher.rx.isOn.asObservable()
            .bindTo(userSwitchValue)
            .addDisposableTo(disposeBag)
        
        _ = switcher.rx.isOn.asObservable()
            .map({ (value) -> String in
                return value ? NSLocalizedString("yes", comment: "") : NSLocalizedString("no", comment: "")
            })
            .bindTo(self.valueLabel.rx.text)
            .addDisposableTo(disposeBag)
    }
    
    func update(propertyName: String, value: Bool) {
        propertyTitleLabel.text = propertyName
        switcher.setOn(value, animated: false)
        valueLabel.text = value ? NSLocalizedString("yes", comment: "") : NSLocalizedString("no", comment: "")
    }
    
}

extension ColumnBoolPropertyTVCell {
    // MARK: Setup UI
    
    func setupUI() {
        
    }
    
}

extension ColumnBoolPropertyTVCell {
    // MARK: Animations
    
    private func animationDuration() -> CGFloat {
        return 0.2 as CGFloat
    }
    
    private func switcherFrame(editing: Bool) -> CGRect {
        let size = CGSize(width: 51, height: 31)
        let yCoord = (self.frame.size.height - size.height) / 2
        let trailingOffset = 15.0 as CGFloat
        let xCoord = editing ? self.frame.size.width - size.width - trailingOffset : self.frame.size.width
        return CGRect(x: xCoord, y: yCoord, width: size.width, height: size.height)
    }
    
    private func valueLabelFrame(editing: Bool) -> CGRect {
        let size = CGSize(width: editing ? 90 : 135, height: 20)
        let yCoord = (self.frame.size.height - size.height) / 2
        let trailingOffset = (editing ? 5.0 : 15.0) as CGFloat
        let xCoord = editing ? self.switcherFrame(editing: editing).origin.x - size.width - trailingOffset : self.frame.size.width - size.width - trailingOffset
        return CGRect(x: xCoord, y: yCoord, width: size.width, height: size.height)
    }
    
    func runEditingStateAnimation() {
        let switchControlAnimation = POPBasicAnimation(propertyNamed: kPOPViewFrame)
        let valueLabelAnimation = POPBasicAnimation(propertyNamed: kPOPViewFrame)
        
        for animation in [switchControlAnimation, valueLabelAnimation] {
            animation?.duration = CFTimeInterval(self.animationDuration())
        }
        
        switchControlAnimation?.toValue = switcherFrame(editing: true)
        valueLabelAnimation?.toValue = valueLabelFrame(editing: true)
        
        valueLabel.pop_add(valueLabelAnimation, forKey: "valueLabelAnimationHide")
        switcher.pop_add(switchControlAnimation, forKey: "switchControlAnimationShow")
    }
    
    func runNormalStateAnimation() {
        let switchControlAnimation = POPBasicAnimation(propertyNamed: kPOPViewFrame)
        let valueLabelAnimation = POPBasicAnimation(propertyNamed: kPOPViewFrame)
        
        for animation in [switchControlAnimation, valueLabelAnimation] {
            animation?.duration = CFTimeInterval(self.animationDuration())
        }
        
        switchControlAnimation?.toValue = switcherFrame(editing: false)
        valueLabelAnimation?.toValue = valueLabelFrame(editing: false)
        
        switcher.pop_add(switchControlAnimation, forKey: "switchControlAnimationHide")
        valueLabel.pop_add(valueLabelAnimation, forKey: "valueLabelAnimationShow")
    }
    
}
