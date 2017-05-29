//
//  HamburgerButton.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import pop
import RxSwift

class HamburgerButton: UIButton {
    
    let disposeBag = DisposeBag()
    
    let rectangleTop = UIView()
    let rectangleMiddle = UIView()
    let rectangleBottom = UIView()

    let isSelectedState = Variable<Bool>(false)
    
    var animationDuration : CGFloat = 0.2
    
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
    
    func initBindings() {
        
        _ = isSelectedState.asObservable()
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { [unowned self] (_) in
            UIView.animate(withDuration: 0.2,
                           animations: { 
                            self.layoutSubviews()
            })
        })
        .disposed(by: disposeBag)
        
    }
    
    func setHamburgerState(hamburgerSelected: Bool) {
        DispatchQueue.main.async { [unowned self] in
            self.isSelectedState.value = hamburgerSelected
        }
    }
    
    func switchSelected() {
        self.setHamburgerState(hamburgerSelected: !isSelectedState.value)
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        let widthToAdd = 40.0 as CGFloat
        let heightToAdd = 40.0 as CGFloat
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        return (largerFrame.contains(point)) ? self : nil
    }
    
}

extension HamburgerButton { // MARK: Setup UI
    
    fileprivate func setupUI() {
        self.setupViews()
        self.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)
    }
    
    fileprivate func setupViews() {
        for rectangle in [rectangleTop, rectangleMiddle, rectangleBottom] {
            rectangle.backgroundColor = UIColor.black
            rectangle.isUserInteractionEnabled = false
            rectangle.layer.cornerRadius = 2.0
            self.addSubview(rectangle)
        }
    }
    
}

extension HamburgerButton { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.rectangleTop.frame = self.rectangleFrame(index: 0)
        self.rectangleMiddle.frame = self.rectangleFrame(index: 1)
        self.rectangleBottom.frame = self.rectangleFrame(index: 2)
    }
    
    fileprivate func rectangleFrame(index: Int) -> CGRect {
        return self.rectangleFrame(selected: isSelectedState.value, index: index)
    }
    
    fileprivate func rectangleFrame(selected: Bool ,index: Int) -> CGRect {
        let size = CGSize(width: self.frame.size.width, height: self.frame.size.height / 8)
        var yCoord = 0.0 as CGFloat
        
        switch index {
        case 0:
            if selected {
                yCoord = 0.0 as CGFloat
            }else{
                yCoord = size.height as CGFloat
            }
            break
        case 1:
            yCoord = (self.frame.size.height - size.height) / 2 as CGFloat
            break
        case 2:
            if selected {
                yCoord = self.frame.size.height - size.height as CGFloat
            }else{
                yCoord = self.frame.size.height - size.height * 2 as CGFloat
            }
            break
        default:
            break
        }
        
        return CGRect(x: 0, y: yCoord, width: size.width, height: size.height)
    }
}

extension HamburgerButton { // MARK: Actions
    
    @objc func pressed() {
        self.switchSelected()
    }
}

