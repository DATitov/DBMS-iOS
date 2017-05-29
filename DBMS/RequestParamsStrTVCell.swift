//
//  RequestParamsFloatTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 22.03.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class RequestParamsStrTVCell: UITableViewCell {

    @IBOutlet weak var propertyNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var searchStringTextField: UITextField!
    
    class func instanceFromNib() -> RequestParamsStrTVCell {
        return UINib(nibName: "RequestParamsStrTVCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RequestParamsStrTVCell
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func switched(_ sender: UISwitch) {
        self.searchStringTextField.isUserInteractionEnabled = sender.isOn
    }
}
