//
//  AlertViewButton.swift
//  DBMS
//
//  Created by Dmitrii Titov on 13.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import pop
import RxSwift
import RxCocoa

class AlertViewButton: UIButton {
    
    let disposeBag = DisposeBag()
    
    init() {
        super.init(frame: .zero)
        self.setupUI()
        self.initBindings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.initBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        self.initBindings()
    }
    
    func setupUI() {
        backgroundColor = CommonCollorsStorage.cellBackgroundColor()
        layer.cornerRadius = 3
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.5
        self.setTitleColor(UIColor.black, for: .normal)
        
        self.addTarget(self, action: #selector(self.touchStart), for: .touchDown)
        self.addTarget(self, action: #selector(self.touchFinish), for: .touchUpInside)
        self.addTarget(self, action: #selector(self.touchFinish), for: .touchCancel)
        self.addTarget(self, action: #selector(self.touchFinish), for: .touchDragExit)
        self.addTarget(self, action: #selector(self.touchFinish), for: .touchDragOutside)
    }
    
    func initBindings() {
        self.rx.observe(Bool.self, "enabled").asObservable()
            .distinctUntilChanged({ (en1, en2) -> Bool in
             return en1 != nil && en1 != nil && en1 == en2
             })
            .subscribe(onNext: { (enabled) in
                guard enabled != nil else {
                    return
                }
                DispatchQueue.main.async { [unowned self] in
                    if enabled! {
                        self.runEnabledStateAnimation()
                    }else{
                        self.runDisabledStateAnimation()
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
    
}

extension AlertViewButton { // MARK: Actions
    
    @objc func touchStart() {
        self.runTouchStartAnimation()
    }
    
    @objc func touchFinish() {
        self.runTouchFinishAnimation()
    }
    
}

extension AlertViewButton { // MARK: Animations
    
    private func animationDuration() -> CGFloat {
        return 0.15
    }
    
    func runTouchStartAnimation() {
        let borderWidhtAnimation = POPBasicAnimation(propertyNamed: kPOPLayerBorderWidth)
        let colorAnimaton = POPBasicAnimation(propertyNamed: kPOPViewBackgroundColor)
        for animation in [borderWidhtAnimation, colorAnimaton] {
            animation?.duration = CFTimeInterval(self.animationDuration())
        }
        borderWidhtAnimation?.toValue = (0.3)
        colorAnimaton?.toValue = CommonCollorsStorage.cellBackgroundColorHighlighted()
        self.layer.pop_add(borderWidhtAnimation, forKey: "borderWidhtAnimationTouchStart")
        self.pop_add(colorAnimaton, forKey: "colorAnimatonTouchStart")
    }
    
    func runTouchFinishAnimation() {
        let borderWidhtAnimation = POPBasicAnimation(propertyNamed: kPOPLayerBorderWidth)
        let colorAnimaton = POPBasicAnimation(propertyNamed: kPOPViewBackgroundColor)
        for animation in [borderWidhtAnimation, colorAnimaton] {
            animation?.duration = CFTimeInterval(self.animationDuration())
        }
        borderWidhtAnimation?.toValue = (1.5)
        colorAnimaton?.toValue = CommonCollorsStorage.cellBackgroundColor()
        self.layer.pop_add(borderWidhtAnimation, forKey: "borderWidhtAnimationTouchFinish")
        self.pop_add(colorAnimaton, forKey: "colorAnimatonTouchFinish")
    }
    
    func runDisabledStateAnimation() {
        let alphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        for animation in [alphaAnimation] {
            animation?.duration = CFTimeInterval(self.animationDuration())
        }
        alphaAnimation?.toValue = (0.5)
        self.pop_add(alphaAnimation, forKey: "alphaAnimationReduce")
    }
    
    func runEnabledStateAnimation() {
        let alphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        for animation in [alphaAnimation] {
            animation?.duration = CFTimeInterval(self.animationDuration())
        }
        alphaAnimation?.toValue = (1.0)
        self.pop_add(alphaAnimation, forKey: "alphaAnimationIncrease")
    }
    
}
