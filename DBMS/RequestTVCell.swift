//
//  RequestTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class RequestTVCellModel: NSObject {
    var name = ""
    var attributesCount = 0
    
    init(request: RequestRealmObject) {
        super.init()
        name = request.name
        attributesCount = request.selectionAttributes.count
    }
}

class RequestTVCell: BackgroundTVCell {

    let nameLabel = UILabel()
    let attributesCountLabel: UILabel = {
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
        contentView.addSubview(nameLabel)
        contentView.addSubview(attributesCountLabel)
    }
    
    func update(model: RequestTVCellModel) {
        nameLabel.text = model.name
        attributesCountLabel.text = "\(model.attributesCount)"
    }
    
}

extension RequestTVCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horisontalOffset = 15.0 as CGFloat
        let width = 100.0 as CGFloat
        nameLabel.frame = CGRect(x: horisontalOffset, y: 0, width: width, height: contentView.frame.size.height)
        attributesCountLabel.frame = CGRect(x: contentView.frame.size.width - width - horisontalOffset, y: 0,
                                 width: width, height: contentView.frame.size.height)
    }
    
}
