//
//  EnterButtonTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 24.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

protocol EnterButtonTVCellDelegate: class {
    func buttonPressed()
}

class EnterButtonTVCell: UITableViewCell {

    weak var delegate: EnterButtonTVCellDelegate?
    
    let enterButton = SaveButton()
    
    var buttonTitle = "" {
        didSet {
            self.enterButton.setTitle(self.buttonTitle, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(enterButton)
        enterButton.setTitle("Enter", for: .normal)
        enterButton.addTarget(self, action: #selector(self.buttonPressed), for: .touchUpInside)
    }

}

extension EnterButtonTVCell {
    
    @objc func buttonPressed() {
        if delegate != nil {
            delegate?.buttonPressed()
        }
    }
    
}

extension EnterButtonTVCell { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = CGSize(width: 100, height: 60)
        enterButton.frame = CGRect(x: (self.frame.size.width - size.width) / 2, y: (self.frame.size.height - size.height) / 2,
                                   width: size.width, height: size.height)
    }
    
}
