//
//  OneLabelTVHeader.swift
//  DBMS
//
//  Created by Dmitrii Titov on 17.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class OneLabelTVHeader: UITableViewHeaderFooterView {

    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    let backgroundLayerView = UIButton()
    let backgroundButtonShapeLayer = CAShapeLayer()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(backgroundLayerView)
        contentView.addSubview(label)
        
        backgroundLayerView.layer.addSublayer(backgroundButtonShapeLayer)
        backgroundButtonShapeLayer.fillColor = CommonCollorsStorage.tableViewHeaderBackgroundColor().cgColor
        backgroundButtonShapeLayer.strokeColor = UIColor.black.cgColor
        backgroundButtonShapeLayer.lineWidth = 1.5
        
        contentView.backgroundColor = UIColor.clear
        backgroundLayerView.backgroundColor = UIColor.clear
    }
    
    func update(title: String) {
        label.text = title
    }
    
}

extension OneLabelTVHeader { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = self.bounds
        self.layoutBackgroundLayer()
    }
    
    func layoutBackgroundLayer() {
        backgroundButtonShapeLayer.frame = backgroundLayerView.bounds
        
        let path = UIBezierPath()
        let cornerRadius = 5.0 as CGFloat
        let horisontalOffset = backgroundButtonShapeLayer.lineWidth as CGFloat
        let verticalOffset = 5.0 as CGFloat
        path.move(to: CGPoint(x: frame.size.width - horisontalOffset - cornerRadius, y: verticalOffset))
        path.addArc(withCenter: CGPoint(x: frame.size.width - horisontalOffset - cornerRadius, y: verticalOffset + cornerRadius), radius: cornerRadius,
                    startAngle: self.degreesToRadians(degrees: -90), endAngle: self.degreesToRadians(degrees: 0), clockwise: true)
        path.addArc(withCenter: CGPoint(x: frame.size.width - cornerRadius - horisontalOffset, y: frame.size.height - verticalOffset - cornerRadius),
                    radius: cornerRadius, startAngle: self.degreesToRadians(degrees: 0), endAngle: self.degreesToRadians(degrees: 90), clockwise: true)
        path.addArc(withCenter: CGPoint(x: cornerRadius + horisontalOffset, y: frame.size.height - cornerRadius - verticalOffset), radius: cornerRadius,
                    startAngle: self.degreesToRadians(degrees: 90), endAngle: self.degreesToRadians(degrees: 180), clockwise: true)
        path.addArc(withCenter: CGPoint(x: cornerRadius + horisontalOffset, y: cornerRadius + verticalOffset), radius: cornerRadius,
                    startAngle: self.degreesToRadians(degrees: 180), endAngle: self.degreesToRadians(degrees: 270), clockwise: true)
        path.addLine(to: CGPoint(x: frame.size.width - horisontalOffset - cornerRadius, y: verticalOffset))
        
        backgroundButtonShapeLayer.path = path.cgPath
        
    }
    
    private func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * .pi / 180
    }
    
}
