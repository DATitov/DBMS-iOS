//
//  AttributeEditingTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 23.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class AttributeEditingTVCellModel: TablesListEditingCellModel {
    var typeText: String = ""
    var isForeignKey: Bool = false
    
    init(titleText: String, typeText: String, isEditing: Bool, selected: Bool, isForeignKey: Bool) {
        super.init(titleText: titleText, isEditing: isEditing, selected: selected)
    }
    
}

class AttributeEditingTVCell: TablesListEditingCell {
    
    let dataTypeLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupAttributeEditingTVCellUI()
        self.initTablesListEditingCellBindings()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupAttributeEditingTVCellUI()
        self.initTablesListEditingCellBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupAttributeEditingTVCellUI()
        self.initTablesListEditingCellBindings()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupAttributeEditingTVCellUI()
        self.initTablesListEditingCellBindings()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func updateAttributeEditingTVCell(model: AttributeEditingTVCellModel) {
        super.update(model: model)
        titleLabel.text = model.titleText
        selectionButton.buttonSelected = model.selected
        editingState.value = model.isEditing
    }
        
}

extension AttributeEditingTVCell { // MARK: Setup UI
    
    func setupAttributeEditingTVCellUI() {
        self.setupTablesListEditingCellViews()
        self.configureTablesListEditingCellView()
    }
    
    func configureAttributeEditingTVCellView() {
        self.layoutViews()
    }
    
    func setupAttributeEditingTVCellViews() {
        self.setupTablesListEditingCellLabels()
    }
    
    func setupAttributeEditingTVCellLabels() {
        contentView.addSubview(dataTypeLabel)
        dataTypeLabel.textAlignment = .right
    }
    
}

extension AttributeEditingTVCell { //   MARK: Layout
    
    override func layoutViews() {
        super.layoutViews()
        dataTypeLabel.frame = dataTypeLabelFrame(selectionState: editingState.value)
    }
    
    override func titleLabelFrame(selectionState: Bool) -> CGRect {
        let horisonlatOffset = 10.0 as CGFloat
        let bbFrame = self.backgroundButtonFrame(selectionState: selectionState)
        return CGRect(x: horisonlatOffset, y: 0, width: (bbFrame.size.width * 2 / 3) - horisonlatOffset, height: bbFrame.size.height)
    }
    
    func dataTypeLabelFrame(selectionState: Bool) -> CGRect {
        let horisonlatOffset = 15.0 as CGFloat
        let tlFrame = self.titleLabelFrame(selectionState: selectionState)
        return CGRect(x: tlFrame.size.width, y: 0, width: (tlFrame.size.width / 3) - horisonlatOffset, height: tlFrame.size.height)
    }
    
}
