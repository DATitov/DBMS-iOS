//
//  RequestEditConditionItemBackgroundView.swift
//  DBMS
//
//  Created by Dmitrii Titov on 23.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class RequestEditConditionItemBackgroundView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    func setupUI() {
        backgroundColor = UIColor.clear
        layer.backgroundColor = CommonCollorsStorage.cellBackgroundColor().cgColor
        layer.cornerRadius = 5
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.5
    }

}
