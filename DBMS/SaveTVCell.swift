//
//  SaveTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 23.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class SaveTVCell: UITableViewCell {

    let saveButton = SaveButton()
    
    var saveButtonAction : (() -> ())!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension SaveTVCell { // MARK: Setup UI
    
    func setupUI() {
        self.setupButtons()
    }
    
    func setupButtons() {
        contentView.addSubview(saveButton)
        saveButton.addTarget(self, action: #selector(self.savebuttonPressed), for: .touchUpInside)
    }
    
}

extension SaveTVCell { // MARK: Setup UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layoutButtons()
    }
    
    func layoutButtons() {
        let bottomSpace = 30.0 as CGFloat
        let height = 40.0 as CGFloat
        let width = 70.0 as CGFloat
        saveButton.frame = CGRect(x: (self.frame.size.width - width) / 2, y: self.frame.size.height - bottomSpace - height,
                                  width: width, height: height)
    }
    
}

extension SaveTVCell { // MARK: Actions
    
    @objc func savebuttonPressed() {
        if saveButtonAction != nil {
            saveButtonAction()
        }
    }
    
}

