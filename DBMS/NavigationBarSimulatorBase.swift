//
//  NavigationBarSimulatorBase.swift
//  DBMS
//
//  Created by Dmitrii Titov on 13.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NavigationBarSimulatorBase: UIView {
    
    let titleLabel = UILabel()
    let backButton = UIButton()
    let backgroundLayerView = UIView()
    
    var backButtonPressedAction : (() -> ())?
    
    var title : String = "" {
        didSet {
            DispatchQueue.main.async { [unowned self] in
                self.titleLabel.text = self.title
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupBaseUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupBaseUI()
    }
    
}

extension NavigationBarSimulatorBase { // MARK: Setup UI
    
    func setupBaseUI() {
        self.setupBaseViews()
        self.setupBaseLayers()
        self.configureView()
    }
    
    func configureView() {
        self.backgroundColor = UIColor.clear
    }
    
    func setupBaseViews() {
        self.setupBaseBackgroundView()
        self.setupBaseLabels()
        self.setupBaseButtons()
    }
    
    func setupBaseBackgroundView() {
        self.addSubview(backgroundLayerView)
        /*
        backgroundLayerView.backgroundColor = UIColor.clear
        self.insertSubview(backgroundLayerView, belowSubview: self)
 */
    }
    
    func setupBaseButtons() {
        self.addSubview(backButton)
        backButton.setTitle(NSLocalizedString("back", comment: ""), for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.titleLabel?.textAlignment = .left
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
    }
    
    func setupBaseLabels() {
        self.addSubview(titleLabel)
        titleLabel.textAlignment = .center
    }
    
    func setupBaseLayers() {
        self.setupBaseShapeLayers()
    }
    
    func setupBaseShapeLayers() {
        backgroundLayerView.backgroundColor = CommonCollorsStorage.navigationBarBackgroundColor()
        backgroundLayerView.layer.cornerRadius = 10
        backgroundLayerView.layer.borderColor = UIColor.black.cgColor
        backgroundLayerView.layer.borderWidth = 1.5
    }
}

extension NavigationBarSimulatorBase { // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let leadingOffset = 15.0 as CGFloat
        let topOffset = 10.0 as CGFloat
        let betweenTitleAndButtonsSpace = 10.0 as CGFloat
        let backButtonSize = CGSize(width: 50, height: self.frame.size.height)
        let titleLabelSize = CGSize(width: self.frame.size.width - (leadingOffset + backButtonSize.width + betweenTitleAndButtonsSpace) * 2,
                                    height: self.frame.size.height - topOffset)
        
        backButton.frame = CGRect(x: leadingOffset, y: topOffset,
                                  width: backButtonSize.width, height: backButtonSize.height - topOffset)
        titleLabel.frame = CGRect(x: leadingOffset + backButtonSize.width + betweenTitleAndButtonsSpace, y: topOffset,
                                  width: titleLabelSize.width, height: titleLabelSize.height)
        backgroundLayerView.frame = CGRect(x: 0, y: -backgroundLayerView.layer.cornerRadius,
                                           width: self.frame.width, height: self.frame.height + backgroundLayerView.layer.cornerRadius)
        
    }
}

extension NavigationBarSimulatorBase { // MARK: Actions
    
    @objc fileprivate func backButtonPressed() {
        if backButtonPressedAction != nil {
            backButtonPressedAction!()
        }
    }
    
}

