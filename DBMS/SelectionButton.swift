//
//  SelectionButton.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import pop

class SelectionButton: UIButton {

    var buttonSelected:  Bool = false {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                if self.buttonSelected {
                    self.runSelectAnimation()
                }else{
                    self.runUnselectAnimation()
                }
            }
        }
    }
    
    var positive: Bool = false {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.updateImage(positive: self.positive)
            }
        }
    }
    
    let backgroundView = UIView()
    let backgroundViewLayer = CALayer()
    let foregroundImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
}

extension SelectionButton { // MARK: Setup UI
    
    fileprivate func setupUI() {
        self.setupViews()
        self.setupLayers()
        self.configureView()
    }
    
    fileprivate func configureView() {
        self.addTarget(self, action: #selector(self.highlighted), for: .touchDown)
        self.addTarget(self, action: #selector(self.unhighlighted), for: .touchUpInside)
        self.addTarget(self, action: #selector(self.canceled), for: .touchCancel)
        self.addTarget(self, action: #selector(self.canceled), for: .touchDragExit)
        self.addTarget(self, action: #selector(self.canceled), for: .touchDragOutside)
    }
    
    fileprivate func setupViews() {
        self.addSubview(backgroundView)
        backgroundView.isUserInteractionEnabled = false
        self.setupImageViews()
    }
    
    fileprivate func setupImageViews() {
        self.addSubview(foregroundImageView)
        foregroundImageView.isUserInteractionEnabled = false
        foregroundImageView.alpha = 0
        foregroundImageView.layer.cornerRadius = 5
        foregroundImageView.layer.masksToBounds = true
        self.updateImage(positive: positive)
    }
    
    fileprivate func setupLayers() {
        backgroundView.layer.addSublayer(backgroundViewLayer)
        backgroundViewLayer.borderColor = UIColor.red.cgColor
        backgroundViewLayer.borderWidth = 2.5
        backgroundViewLayer.cornerRadius = 4
    }
    
    fileprivate func updateImage(positive: Bool) {
        var image : UIImage
        if positive {
            image = UIImage(named: "selection_icon")!
            foregroundImageView.tintColor = UIColor.green
        }else {
            image = UIImage(named: "dlt_selection_icon")!
            foregroundImageView.tintColor = UIColor.red
        }
        foregroundImageView.image = image
    }
    
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if self.isHidden || !self.isUserInteractionEnabled || self.alpha < 0.01 { return nil }
        let widthToAdd = 50.0 as CGFloat
        let heightToAdd = 50.0 as CGFloat
        let largerFrame = self.bounds.insetBy(dx: -widthToAdd / 2, dy: -heightToAdd / 2)
        return (largerFrame.contains(point)) ? self : nil
    }
    
}

extension SelectionButton { // MARK: Animations
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutViews()
        self.layoutLayers()
    }
    
    func layoutViews() {
        backgroundView.frame = self.bounds
        foregroundImageView.frame = self.bounds
    }
    
    func layoutLayers() {
        backgroundViewLayer.frame = backgroundView.bounds
    }
    
}

extension SelectionButton { // MARK: Actions
    
    @objc fileprivate func highlighted() {
        self.runHighlightAnimation()
    }
    
    @objc fileprivate func unhighlighted() {
        buttonSelected = !buttonSelected
        /*
        if buttonSelected {
            self.runSelectAnimation()
        }else{
            self.runUnselectAnimation()
        }
 */
    }
    
    @objc fileprivate func canceled() {
        self.runUnhighlightAnimation()
    }
}

extension SelectionButton { // MARK: Animations
    
    fileprivate func runSelectAnimation() {
        let sizeAnimation = POPSpringAnimation(propertyNamed: kPOPViewSize)
        let imageAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        sizeAnimation?.toValue = NSValue(cgSize: self.frame.size)
        imageAlphaAnimation?.toValue = 1.0
        imageAlphaAnimation?.duration = 0.2
        
        backgroundView.pop_add(sizeAnimation, forKey: "selectionSizeAnimation")
        foregroundImageView.pop_add(imageAlphaAnimation, forKey: "selectionAlphaAnimation")
    }
    
    fileprivate func runUnselectAnimation() {
        let sizeAnimation = POPSpringAnimation(propertyNamed: kPOPViewSize)
        let imageAlphaAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        
        sizeAnimation?.toValue = NSValue(cgSize: self.frame.size)
        imageAlphaAnimation?.toValue = 0.0
        imageAlphaAnimation?.duration = 0.2
        
        backgroundView.pop_add(sizeAnimation, forKey: "unselectionSizeAnimation")
        foregroundImageView.pop_add(imageAlphaAnimation, forKey: "unselectionAlphaAnimation")
    }
    
    fileprivate func runHighlightAnimation() {
        let sizeAnimation = POPBasicAnimation(propertyNamed: kPOPViewSize)
        sizeAnimation?.toValue = NSValue(cgSize: CGSize(width: self.frame.size.width + 20, height: self.frame.size.height + 20))
        sizeAnimation?.duration = 0.2
        backgroundView.pop_add(sizeAnimation, forKey: "highlightSizeanimation")
    }
    
    fileprivate func runUnhighlightAnimation() {
        let sizeAnimation = POPBasicAnimation(propertyNamed: kPOPViewSize)
        sizeAnimation?.toValue = NSValue(cgSize: self.frame.size)
        sizeAnimation?.duration = 0.2
        backgroundView.pop_add(sizeAnimation, forKey: "unhighlightSizeanimation")
    }
    
    
}
