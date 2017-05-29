//
//  RelationshipSideBackgroundView.swift
//  DBMS
//
//  Created by Dmitrii Titov on 18.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class RelationshipSideBackgroundView: UIView {

    let shapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }

    init() {
        super.init(frame: .zero)
        self.setupUI()
    }
    
    func setupUI() {
        layer.addSublayer(shapeLayer)
        shapeLayer.fillColor = CommonCollorsStorage.cellBackgroundColorHighlighted().cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        shapeLayer.lineWidth = 1.5
        backgroundColor = UIColor.clear
    }
    
}

extension RelationshipSideBackgroundView { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shapeLayer.frame = self.bounds
        
        let path = UIBezierPath()
        let cornerRadius = 5.0 as CGFloat
        let horisontalOffset = 5.0 as CGFloat
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
        
        shapeLayer.path = path.cgPath
    }
    
    private func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * .pi / 180
    }
    
}
