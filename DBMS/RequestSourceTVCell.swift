//
//  RequestSourceItemTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class RequestSourceTVCellModel: NSObject {
    var sourceName = ""
}

class RequestSourceTVCell: BackgroundTVCell {
    
    let sourceNameLabelTitle = { () -> UILabel in
        let label = UILabel()
        label.text = NSLocalizedString("from", comment: "") + ":"
        return label
    }()
    let sourceNameLabelValue = { () -> UILabel in 
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
        contentView.addSubview(sourceNameLabelTitle)
        contentView.addSubview(sourceNameLabelValue)
    }
    
    func update(model: RequestSourceTVCellModel) {
        sourceNameLabelValue.text = model.sourceName
    }

}

extension RequestSourceTVCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horisontalOffset = 15.0 as CGFloat
        let height = contentView.frame.size.height
        let bigWidth = (contentView.frame.size.width - horisontalOffset * 2) * 2 / 3
        let smallWidth = (contentView.frame.size.width - horisontalOffset * 2) / 3
        
        sourceNameLabelTitle.frame = CGRect(x: horisontalOffset, y: 0,
                                            width: smallWidth, height: height)
        sourceNameLabelValue.frame = CGRect(x: contentView.frame.size.width - bigWidth - horisontalOffset * 2, y: 0,
                                            width: bigWidth, height: height)
    }
    
}
