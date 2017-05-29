//
//  TablesListEditingCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import pop
import RxSwift

class TablesListEditingCellModel: NSObject {
    var isEditing: Bool = false
    var selected: Bool = false
    var titleText: String = ""
    
    init(titleText: String, isEditing: Bool, selected: Bool) {
        super.init()
        self.titleText = titleText
        self.isEditing = isEditing
        self.selected = selected
    }
}

class TablesListEditingCell: BackgroundTVCell {
    
    let editingState = Variable<Bool>(false)
    var previousState : Bool = false
    
    
    var cellSelected : Bool = false {
        didSet {
            
        }
    }
    
    let selectionButton = SelectionButton(frame: .zero)
    let selectionButtonBackgroundLayer = CALayer()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupTablesListEditingCellUI()
        self.initTablesListEditingCellBindings()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupTablesListEditingCellUI()
        self.initTablesListEditingCellBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupTablesListEditingCellUI()
        self.initTablesListEditingCellBindings()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupTablesListEditingCellUI()
        self.initTablesListEditingCellBindings()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)        
    }
    
    func initTablesListEditingCellBindings() {
        
        editingState.asObservable()
        .subscribe { (editing) in
            DispatchQueue.main.async { [unowned self] in
                    if editing.element! {
                        self.titleLabel.textAlignment = .left
                    }else{
                        self.titleLabel.textAlignment = .center
                    }
                self.previousState = editing.element!
            }
        }        
        
    }

    func update(model: TablesListEditingCellModel) {
        titleLabel.text = model.titleText
        selectionButton.buttonSelected = model.selected
        editingState.value = model.isEditing
    }
    
}

extension TablesListEditingCell { //   MARK: Setup UI
    
    func setupTablesListEditingCellUI() {
        self.setupTablesListEditingCellViews()
        self.setupTablesListEditingCellLayers()
        self.configureTablesListEditingCellView()
    }
    
    func configureTablesListEditingCellView() {
        self.layoutViews()
        self.layoutLayers()
    }
    
    func setupTablesListEditingCellViews() {
        self.setupTablesListEditingCellButtons()
        self.setupTablesListEditingCellLabels()
    }
    
    func setupTablesListEditingCellButtons() {
        contentView.addSubview(selectionButton)
        selectionButton.addTarget(self, action: #selector(self.selectButtonPressed), for: .touchUpInside)
        selectionButton.buttonSelected = false
        selectionButton.isUserInteractionEnabled = false
    }
    
    func setupTablesListEditingCellLabels() {
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
    }
    
    func setupTablesListEditingCellLayers() {
        selectionButton.layer.addSublayer(selectionButtonBackgroundLayer)
    }
}

extension TablesListEditingCell { //   MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutViews()
        self.layoutLayers()
    }
    
    func layoutViews() {
        selectionButton.frame = self.selectionButtonFrame(selectionState: editingState.value)
        titleLabel.frame = self.titleLabelFrame(selectionState: editingState.value)
    }
    
    func layoutLayers() {
        
    }
    
    fileprivate func selectionButtonFrame(selectionState: Bool) -> CGRect{
        let height = 32.0 as CGFloat
        let size = CGSize(width: height, height: height)
        let yCoord = (self.frame.size.height - size.height) / 2 as CGFloat
        let xCoord = selectionState ? 15.0 as CGFloat : -size.width - 47
        return CGRect(x: xCoord, y: yCoord, width: size.width, height: size.height)
    }
    
    func backgroundButtonFrame(selectionState: Bool) -> CGRect {
        let xCoord = selectionState ? 62.0 as CGFloat : 0 as CGFloat
        return CGRect(x: xCoord, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    func titleLabelFrame(selectionState: Bool) -> CGRect {
        let horisonlatOffset = 15.0 as CGFloat
        let bbFrame = self.backgroundButtonFrame(selectionState: selectionState)
        return CGRect(x: horisonlatOffset, y: 0, width: bbFrame.size.width - horisonlatOffset * 2, height: bbFrame.size.height)
    }
    
}

extension TablesListEditingCell { //   MARK: Actions
    
    @objc func selectButtonPressed() {
        cellSelected = !cellSelected
    }
    
}
