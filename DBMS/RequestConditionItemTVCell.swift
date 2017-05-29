//
//  RequestConditionItemTVCell.swift
//  Pods
//
//  Created by Dmitrii Titov on 20.05.17.
//
//

import UIKit

class RequestConditionItemTVCellModel: NSObject {
    var pathText = ""
    var typeText = ""
    var valueText = ""
    
    override init() {
        super.init()
    }
    
    init(requestConditionItem: RequestConditionItem) {
        super.init()
        if requestConditionItem.selectedItem != nil {
            pathText = (requestConditionItem.selectedItem?.requestName)! + "." + (requestConditionItem.selectedItem?.attributeName)!
        }else{
            pathText = ""
        }
        typeText = requestConditionItem.type
        valueText = requestConditionItem.value
    }
    
}

class RequestConditionItemTVCell: BackgroundTVCell {
    
    let pathLabel = UILabel()
    let typeLabel = { () -> UILabel in 
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    let valueLabel = { () -> UILabel in 
        let label = UILabel()
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }

    func setupUI() {
        contentView.addSubview(pathLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(valueLabel)
    }
    
    func update(model: RequestConditionItemTVCellModel) {
        pathLabel.text = model.pathText
        typeLabel.text = model.typeText
        valueLabel.text = model.valueText
    }

}

extension RequestConditionItemTVCell { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horisontalOffset = 15.0 as CGFloat
        let bigWidth = (contentView.frame.size.width - horisontalOffset * 2) * 2 / 5
        let smallWidth = (contentView.frame.size.width - horisontalOffset * 2) / 5
        let height = contentView.frame.size.height
        
        pathLabel.frame = CGRect(x: horisontalOffset, y: 0, width: bigWidth, height: height)
        typeLabel.frame = CGRect(x: horisontalOffset + bigWidth, y: 0, width: smallWidth, height: height)
        valueLabel.frame = CGRect(x: horisontalOffset + bigWidth + smallWidth, y: 0, width: bigWidth, height: height)
    }
    
}
