//
//  TwoLabelTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 22.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class TwoLabelTVCell: BackgroundTVCell {
    
    let label1 = UILabel()
    let label2: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(label1)
        contentView.addSubview(label2)
    }
    
    func update(text1: String, text2: String) {
        label1.text = text1
        label2.text = text2
    }
    
}

extension TwoLabelTVCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horisontalOffset = 15.0 as CGFloat
        let betweenSpace = 10.0 as CGFloat
        let width = (self.frame.size.width - horisontalOffset * 2 - betweenSpace) / 2
        label1.frame = CGRect(x: horisontalOffset, y: 0,
                              width: width, height: self.frame.size.height)
        label2.frame = CGRect(x: self.frame.size.width - width - horisontalOffset, y: 0,
                              width: width, height: self.frame.size.height)
    }
    
}
