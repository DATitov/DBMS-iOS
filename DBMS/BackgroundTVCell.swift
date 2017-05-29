//
//  BackgroundTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 17.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxCocoa

class BackgroundTVCell: UITableViewCell {
    
    let backgroundLayerView = UIView()
    //let backgroundButtonShapeLayer = CALayer()//CAShapeLayer()
        
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupBackgroundTVCellUI()
    }
    
    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.setupBackgroundTVCellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupBackgroundTVCellUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupBackgroundTVCellUI()
    }
    
}

extension BackgroundTVCell { //   MARK: Setup UI
    
    func setupBackgroundTVCellUI() {
        self.setupBackgroundTVCellViews()
        self.setupBackgroundTVCellLayers()
        self.configureBackgroundTVCellView()
    }
    
    func configureBackgroundTVCellView() {
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
    }
    
    func setupBackgroundTVCellViews() {
        contentView.insertSubview(backgroundLayerView, at: 0)
        backgroundLayerView.backgroundColor = CommonCollorsStorage.cellBackgroundColor()
        backgroundLayerView.layer.cornerRadius = 5
        backgroundLayerView.layer.borderWidth = 1.5
        backgroundLayerView.layer.borderColor = UIColor.black.cgColor
    }
    
    func setupBackgroundTVCellLayers() {
        /*
        backgroundLayerView.layer.addSublayer(backgroundButtonShapeLayer)
        backgroundButtonShapeLayer.fillColor = CommonCollorsStorage.cellBackgroundColor().cgColor
        backgroundButtonShapeLayer.lineWidth = 1.5
        backgroundButtonShapeLayer.strokeColor = UIColor.black.cgColor
 */
    }
}

extension BackgroundTVCell { //   MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayerView.frame = contentView.bounds
        
        let horisontalOffset = 5.0 as CGFloat
        let verticalOffset = 5.0 as CGFloat
        backgroundLayerView.frame = CGRect(x: horisontalOffset, y: verticalOffset,
                                           width: contentView.frame.size.width - horisontalOffset * 2,
                                           height: contentView.frame.size.height - verticalOffset * 2)
    }
    
    private func degreesToRadians(degrees: CGFloat) -> CGFloat {
        return degrees * .pi / 180
    }
}

