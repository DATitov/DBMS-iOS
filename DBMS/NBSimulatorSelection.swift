//
//  NBSelection.swift
//  DBMS
//
//  Created by Dmitrii Titov on 21.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class NBSimulatorSelection: NavigationBarSimulatorBase {

    let selectButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("select", comment: ""), for: .normal)
        button.titleLabel?.textAlignment = .right
        button.setTitleColor(UIColor.black, for: .normal)
        return button
    }()
    
    var selectButtonPressedAction : (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupNBSelectionUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupNBSelectionUI()
    }

    func setupNBSelectionUI() {
        self.addSubview(selectButton)
        selectButton.addTarget(self, action: #selector(self.selectionButtonPressed), for: .touchUpInside)
        backButton.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
    }
    
}

extension NBSimulatorSelection { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horisontalOffset = 15.0 as CGFloat
        let width = 60.0 as CGFloat
        backButton.frame = CGRect(x: horisontalOffset, y: titleLabel.frame.origin.y, width: width, height: titleLabel.frame.height)
        selectButton.frame = CGRect(x: self.frame.size.width - width - horisontalOffset, y: titleLabel.frame.origin.y,
                                    width: width, height: titleLabel.frame.height)
    }
    
}

extension NBSimulatorSelection { // MARK: Actions
    
    @objc fileprivate func selectionButtonPressed() {
        if selectButtonPressedAction != nil {
            selectButtonPressedAction!()
        }
    }
    
}
