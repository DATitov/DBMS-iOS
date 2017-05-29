//
//  TableNameInputCellTableViewCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 22.03.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class TableNameInputCellTableViewCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    class func instanceFromNib() -> TableNameInputCellTableViewCell {
        return UINib(nibName: "TableNameInputCellTableViewCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TableNameInputCellTableViewCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
