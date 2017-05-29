//
//  NBSimulatorWithAddButton.swift
//  DBMS
//
//  Created by Dmitrii Titov on 17.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class NBSimulatorWithAddButton: NavigationBarSimulatorBase {

    fileprivate let addButton = UIButton()
    
    var addButtonPressedAction : (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNBSimulatorWithAddButtonUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNBSimulatorWithAddButtonUI()
    }
}


extension NBSimulatorWithAddButton { // MARK: SetupUI
    
    func setupNBSimulatorWithAddButtonUI() {
        super.setupBaseUI()
        
        self.setupNBSimulatorWithAddButtonButtons()
    }
    
    func setupNBSimulatorWithAddButtonButtons() {
        super.setupBaseButtons()
        
        self.addSubview(addButton)
        addButton.setTitle(NSLocalizedString("add", comment: ""), for: .normal)
        addButton.setTitleColor(UIColor.black, for: .normal)
        addButton.addTarget(self, action: #selector(self.addButtonPressed), for: .touchUpInside)
    }
    
}

extension NBSimulatorWithAddButton { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutViews()
    }
    
    func layoutViews() {
        
        self.layoutButtons()
    }
    
    func layoutButtons() {
        let trailingOffset = 15.0 as CGFloat
        let width = 50.0 as CGFloat
        let topOffset = 10.0 as CGFloat
        addButton.frame = CGRect(x: self.frame.size.width - trailingOffset - width, y: topOffset, width: width, height: self.frame.size.height - topOffset)
    }
    
}

extension NBSimulatorWithAddButton { // MARK: Actions
    
    @objc func addButtonPressed() {
        if addButtonPressedAction != nil {
            addButtonPressedAction!()
        }
    }
    
}
