//
//  DataBaseActionTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 01.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class DataBaseActionTVCell: BackgroundTVCell {

    @IBOutlet weak var label: UILabel!
    /*
    let backgroundLayerView = UIView()
    let backgroundLayer = CALayer()
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    /*
    //  MARK: Setup UI
    
    func setupUI() {
        self.configureViews()
        self.configureLayers()
        self.configureView()
    }
    
    func configureViews() {
        backgroundLayerView.backgroundColor = UIColor.clear
        self.insertSubview(backgroundLayerView, belowSubview: contentView)
    }
    
    func configureLayers() {
        backgroundLayerView.layer.addSublayer(backgroundLayer)
        backgroundLayer.borderWidth = 1.5
        backgroundLayer.borderColor = UIColor.black.cgColor
        backgroundLayer.cornerRadius = 5
        backgroundLayer.backgroundColor = CommonCollorsStorage.cellBackgroundColor().cgColor
    }
    
    func configureView() {
        backgroundColor = UIColor.clear
    }
    
    //  MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let offset = 5 as CGFloat
        backgroundLayerView.frame = self.bounds
        backgroundLayer.frame = CGRect(x: offset, y: offset,
                                       width: backgroundLayerView.frame.size.width - offset * 2,
                                       height: backgroundLayerView.frame.size.height - offset * 2)
    }
    */
}
