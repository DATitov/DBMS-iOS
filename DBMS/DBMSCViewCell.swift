//
//  DBMSCViewCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 01.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class DBMSCViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var backgroundLayerView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.configureView()
    }
    
}

extension DBMSCViewCell {
    // MARK: Setup UI
    
    fileprivate func configureView() {
        backgroundLayerView.layer.borderColor = UIColor.black.cgColor
        backgroundLayerView.layer.borderWidth = 1.5
        backgroundLayerView.layer.backgroundColor = CommonCollorsStorage.cellBackgroundColor().cgColor
        backgroundLayerView.layer.cornerRadius = 7
    }
}

extension DBMSCViewCell { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
