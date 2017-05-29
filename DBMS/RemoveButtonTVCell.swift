//
//  RemoveButtonTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 03.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class RemoveButtonTVCell: BackgroundTVCell {
    
    let label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupRemoveButtonTVCellUI()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.setupRemoveButtonTVCellUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupRemoveButtonTVCellUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupRemoveButtonTVCellUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

extension RemoveButtonTVCell { //   MARK: Setup UI
    
    func setupRemoveButtonTVCellUI() {
        self.setupRemoveButtonTVCellViews()
        self.configureRemoveButtonTVCellView()
    }
    
    func configureRemoveButtonTVCellView() {
        /*
        backgroundButtonShapeLayer.strokeColor = UIColor.red.cgColor
        backgroundButtonShapeLayer.fillColor = UIColor.clear.cgColor
 */
    }
    
    func setupRemoveButtonTVCellViews() {
        self.setupRemoveButtonTVCellLabels()
    }
    
    
    func setupRemoveButtonTVCellLabels() {
        contentView.addSubview(label)
        label.text = NSLocalizedString("remove", comment: "")
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .red
        label.textAlignment = .center
    }
}

extension RemoveButtonTVCell { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.frame = self.bounds
    }
    
}
