//
//  TablesEditingListHeaderView.swift
//  DBMS
//
//  Created by Dmitrii Titov on 17.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class TablesEditingListHeaderView: UITableViewHeaderFooterView {
    
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let addButton = UIButton()
    let removeButton = UIButton()
    
    fileprivate let backgroundLayerView = UIView()
    fileprivate let backgroundLayer = CALayer()
    
    var viewModel : TablesEditingListHeaderVM!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
}

extension TablesEditingListHeaderView { // MARK: Bindings
    
    func bindViewModel(viewModel: TablesEditingListHeaderVM) {
        self.viewModel = viewModel
        self.nameLabel.text = viewModel.dbName
    }
    
}

extension TablesEditingListHeaderView { // MARK: Setup UI
    
    func setupUI() {
        self.setupViews()
        self.setupLayers()
        self.configureView()
    }
    
    func configureView() {
        self.backgroundColor = UIColor.clear
        self.backgroundView?.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
    
    func setupViews() {
        self.setupLabels()
        self.setupButtons()
        
        self.addSubview(backgroundLayerView)
    }
    
    func setupLabels() {
        self.addSubview(nameLabel)
        self.addSubview(descriptionLabel)
    }
    
    func setupButtons() {
        self.addSubview(addButton)
        self.addSubview(removeButton)
        
        addButton.setTitle("+", for: .normal)
        removeButton.setTitle("x", for: .normal)
        
        addButton.setTitleColor(UIColor.black, for: .normal)
        removeButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    func setupLayers() {
        backgroundLayerView.layer.addSublayer(backgroundLayer)
        backgroundLayerView.backgroundColor = UIColor.clear
        backgroundLayer.borderColor = UIColor.black.cgColor
        backgroundLayer.borderWidth = 1.5
        backgroundLayer.backgroundColor = CommonCollorsStorage.tableViewHeaderBackgroundColor().cgColor
        backgroundLayer.cornerRadius = 5
    }
    
}

extension TablesEditingListHeaderView { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutViews()
        self.layputLayers()
    }
    
    func layoutViews() {
        let horisontalOffset = 15.0 as CGFloat
        let verticalOffset = 10.0 as CGFloat
        let labelWidth = self.frame.size.width * 2 / 3
        let height = 20.0 as CGFloat
        nameLabel.frame = CGRect(x: horisontalOffset, y: verticalOffset, width: labelWidth, height: height)
        addButton.frame = CGRect(x: self.frame.size.width / 3 - height / 2, y: nameLabel.frame.origin.y + nameLabel.frame.size.height + verticalOffset,
                                 width: height, height: height)
        removeButton.frame = CGRect(x: self.frame.size.width * 2 / 3 - height / 2, y: addButton.frame.origin.y,
                                    width: height, height: height)
    }
    
    func layputLayers() {
        let horisontalOffset = 5.0 as CGFloat
        let verticalOffset = 5.0 as CGFloat
        backgroundLayer.frame = CGRect(x: horisontalOffset, y: verticalOffset,
                                       width: self.frame.size.width - horisontalOffset * 2, height: self.frame.size.height - verticalOffset * 2)
    }
    
    class func requiredHeight() -> CGFloat {
        return 70.0 as CGFloat
    }
    
}


