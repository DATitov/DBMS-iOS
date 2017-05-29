//
//  OneLabelTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 21.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class OneLabelTVCell: BackgroundTVCell {

    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
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
        contentView.addSubview(label)
    }
    
    func update(text: String) {
        label.text = text
    }
    
}

extension OneLabelTVCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = self.bounds
    }
    
}
