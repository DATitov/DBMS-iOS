//
//  RelationshipTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 17.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class RelationshipTVCellModel: NSObject {
    
    var side1Text = ""
    var side2Text = ""
    
    override init() {
        super.init()
    }
    
    init(relationship: TablesRelationship) {
        super.init()
        guard let side1 = relationship.side1, let side2 = relationship.side2 else {
            return
        }
        side1Text = side1.count + ": " + side1.tableName + "." + side1.propertyName
        side2Text = side2.count + ": " + side2.tableName + "." + side2.propertyName
    }
    
}

class RelationshipTVCell: BackgroundTVCell {
    
    @IBOutlet weak var side1Label: UILabel!
    @IBOutlet weak var side2Label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(model: RelationshipTVCellModel) {
        side1Label.text = model.side1Text
        side2Label.text = model.side2Text
    }
    
}

extension RelationshipTVCell { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let horisobtalOffset = 15.0 as CGFloat
        let labelWidth = 120.0 as CGFloat
                
        side1Label.frame = CGRect(x: horisobtalOffset, y: 0,
                                  width: labelWidth, height: contentView.frame.size.height)
        side2Label.frame = CGRect(x: self.frame.size.width - labelWidth - horisobtalOffset, y: 0,
                                 width: labelWidth, height: contentView.frame.size.height)
    }
    
}
