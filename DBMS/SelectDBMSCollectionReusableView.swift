//
//  SelectDBMSCollectionReusableView.swift
//  DBMS
//
//  Created by Dmitrii Titov on 01.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class SelectDBMSCollectionReusableView: UICollectionReusableView {
    
    let label1 = UILabel()
    let label2 = UILabel()
    let backgroundLayerView = UIView()
    let backgroundLayer = CALayer()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    func configureView() {
        self.addSubview(backgroundLayerView)
        self.addSubview(label1)
        self.addSubview(label2)
        
        label1.textAlignment = .center
        label2.textAlignment = .center
        
        backgroundLayerView.layer.addSublayer(backgroundLayer)
        backgroundLayer.backgroundColor = CommonCollorsStorage.tableViewHeaderBackgroundColor().cgColor
        backgroundLayer.borderColor = UIColor.black.cgColor
        backgroundLayer.borderWidth = 1.5
        backgroundLayer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horisontalOffset = 20.0 as CGFloat
        let verticalOffset = 5.0 as CGFloat
        let h1 = (self.frame.size.height - verticalOffset * 2) * 1.8 / 3
        let h2 = h1 / 2
        
        label1.frame = CGRect(x: 0, y: verticalOffset, width: self.frame.size.width, height: h1)
        label2.frame = CGRect(x: 0, y: label1.frame.size.height + label1.frame.origin.y, width: self.frame.size.width, height: h2)
        backgroundLayerView.frame = self.bounds
        backgroundLayer.frame = CGRect(x: horisontalOffset, y: verticalOffset,
                                       width: self.frame.size.width - horisontalOffset * 2, height: self.frame.size.height - verticalOffset)
    }
    
}
