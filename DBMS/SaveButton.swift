//
//  SaveButton.swift
//  DBMS
//
//  Created by Dmitrii Titov on 21.03.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import pop

class SaveButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.configureView()
    }

    func configureView() {
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.5
        self.layer.cornerRadius = 3
        self.setTitleColor(UIColor.black, for: .normal)
        self.titleLabel?.text = NSLocalizedString("save", comment: "")
        
        self.addTarget(self, action: #selector(self.touchStart), for: .touchDown)
        self.addTarget(self, action: #selector(self.touchFinish), for: .touchUpInside)
        self.addTarget(self, action: #selector(self.touchFinish), for: .touchCancel)
        self.addTarget(self, action: #selector(self.touchFinish), for: .touchDragExit)
        self.addTarget(self, action: #selector(self.touchFinish), for: .touchDragOutside)
    }
    
}

extension SaveButton { // MARK: Actions
    
    @objc func touchStart() {
        self.runTouchStartAnimation()
    }
    
    @objc func touchFinish() {
        self.runTouchFinishAnimation()
    }
    
}

extension SaveButton { // MARK: Animations
    
    private func animationDuration() -> CGFloat {
        return 0.15
    }
    
    func runTouchStartAnimation() {
        let borderWidhtAnimation = POPBasicAnimation(propertyNamed: kPOPLayerBorderWidth)
        for animation in [borderWidhtAnimation] {
            animation?.duration = CFTimeInterval(self.animationDuration())
        }
        borderWidhtAnimation?.toValue = (0.0)
        self.layer.pop_add(borderWidhtAnimation, forKey: "borderWidhtAnimationTouchStart")
    }
    
    func runTouchFinishAnimation() {
        let borderWidhtAnimation = POPBasicAnimation(propertyNamed: kPOPLayerBorderWidth)
        for animation in [borderWidhtAnimation] {
            animation?.duration = CFTimeInterval(self.animationDuration())
        }
        borderWidhtAnimation?.toValue = (1.5)
        self.layer.pop_add(borderWidhtAnimation, forKey: "borderWidhtAnimationTouchFinish")
    }
    
}
