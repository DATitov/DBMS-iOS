//
//  AlertViewBackgroundButton.swift
//  DBMS
//
//  Created by Dmitrii Titov on 18.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class AlertViewBackgroundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    func setupUI() {
        backgroundColor = UIColor(red: 84.0 / 255 , green: 141.0 / 255, blue: 136.0 / 255, alpha: 0.7)
    }

}
