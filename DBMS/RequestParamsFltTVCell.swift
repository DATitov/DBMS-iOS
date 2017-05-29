//
//  RequestParamsStringTVCell.swift
//  DBMS
//
//  Created by Dmitrii Titov on 22.03.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class RequestParamsFltTVCell: UITableViewCell {

    @IBOutlet weak var propertyNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var fromValueTextField: UITextField!
    @IBOutlet weak var toValueTextField: UITextField!
    @IBOutlet weak var switcher: UISwitch!{
        didSet {
            
        }
    }
    
    class func instanceFromNib() -> RequestParamsFltTVCell {
        return UINib(nibName: "RequestParamsFltTVCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RequestParamsFltTVCell
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
        self.fromValueTextField.isUserInteractionEnabled = sender.isOn
        self.toValueTextField.isUserInteractionEnabled = sender.isOn
    }
}
