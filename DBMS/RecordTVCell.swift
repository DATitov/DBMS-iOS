//
//  RecordTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 12.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class RecordTVCell: BackgroundTVCell {
    
    private(set) var tableName = ""
    
    private(set) var requiredHeight = 40.0 as CGFloat
    
    var titlesLabels = [UILabel]()
    var valuesLabels = [UILabel]()
    var separatorsViews = [UIView]()
    
    func update(withEntity tableData: TableData) {
        guard tableData.name.uppercased() != tableName.uppercased() else {
            return
        }
        if TableData.isEmpty(tableData: tableData) { return }
        titlesLabels = [UILabel]()
        valuesLabels = [UILabel]()
        tableName = tableData.name
        
        for subview in contentView.subviews.filter({ $0.isEqual(self.backgroundLayerView) }) {
            if !subview.isEqual(self.backgroundLayerView) {
                subview.removeFromSuperview()
            }
        }
        for property in tableData.properties {
            let titleLabel = UILabel()
            titleLabel.text = property.name
            titleLabel.textAlignment = .left
            let valueLabel = UILabel()
            valueLabel.textAlignment = .right
            titlesLabels.append(titleLabel)
            valuesLabels.append(valueLabel)
        }
        for newSubview in titlesLabels + valuesLabels {
            newSubview.backgroundColor = UIColor.clear
            contentView.addSubview(newSubview)
        }
        for _ in 0..<tableData.properties.count - 1 {
            let separatorView = UIView()
            separatorView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
            contentView.addSubview(separatorView)
            separatorsViews.append(separatorView)
        }
    }
    
    func update(record: RecordPresentationModel) {
        guard valuesLabels.count == record.values.count else {
            return
        }
        for (label, value) in zip(valuesLabels, record.values) {
            label.text = "\(value)"
        }
    }
    
    static func requiredHeight(forTable table:TableData) -> CGFloat {
        let hghtPrms = RecordTVCell.heightParams()
        let count = table.properties.count
        if count < 1 {
            return 40.0
        }else {
            return hghtPrms.topBottomSpace * 2 + (hghtPrms.heigh + hghtPrms.betweenVerticalSpace) * CGFloat(count) -  hghtPrms.betweenVerticalSpace
        }
    }
    
}

extension RecordTVCell { // MARK: Layout
    
    fileprivate static func heightParams() -> (topBottomSpace: CGFloat, heigh: CGFloat, betweenVerticalSpace: CGFloat) {
        return (10.0 as CGFloat, 22.0 as CGFloat, 10.0 as CGFloat)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutLabels()
        self.layoutSeparatorsViews()
    }
    
    func layoutLabels() {
        let hghtPrms = RecordTVCell.heightParams()
        let width = 100.0 as CGFloat
        let height = hghtPrms.heigh
        let betweenVertocalSpace = hghtPrms.betweenVerticalSpace
        let horisontalOffset = 25.0 as CGFloat
        let topOffset = hghtPrms.topBottomSpace
        
        for (index, (titleLabel, valueLabel)) in zip(titlesLabels, valuesLabels).enumerated() {
            titleLabel.frame = CGRect(x: horisontalOffset, y: topOffset + CGFloat(index) * (height + betweenVertocalSpace),
                                      width: width, height: height)
            valueLabel.frame = CGRect(x: self.frame.size.width - width - horisontalOffset, y: topOffset + CGFloat(index) * (height + betweenVertocalSpace),
                                      width: width, height: height)
        }
    }
    
    func layoutSeparatorsViews() {
        let height = 0.5 as CGFloat
        let horisontalOffset = 40.0 as CGFloat
        let betweenSpace = (self.frame.size.height - height * CGFloat(separatorsViews.count)) / CGFloat(titlesLabels.count)
        for (index, separatorView) in separatorsViews.enumerated() {
            separatorView.frame = CGRect(x: horisontalOffset, y: betweenSpace * CGFloat(index + 1),
                                         width: self.frame.width - horisontalOffset * CGFloat(2), height: height)
        }
    }
    
}
