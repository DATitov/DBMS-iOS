//
//  AddRecordCell.swift
//  DBMS
//
//  Created by Александр Кузяев 2 on 21/03/17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation
import UIKit

protocol AddRecordCellDelegate: class {
    func propertyValueChanged(property: TableProperty, value: String)
}

class AddRecordCell: UITableViewCell {
    
    weak var delegate: AddRecordCellDelegate?
        
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelType: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var property: TableProperty! {
        didSet {
            updateLabels()
        }
    }
    
    func update(property: TableProperty) {
        self.property = property
    }
    
    private func updateLabels() {
        labelName.text = property.name
        labelType.text = property.type.rawValue
        updateTextFieldKeyboard()
    }
    
    private func updateTextFieldKeyboard() {
        switch property.type {
        case .Int64:
            textField.keyboardType = .numberPad
            break
        case .Double:
            textField.keyboardType = .decimalPad
            break
        case .String:
            textField.keyboardType = .default
            break
        default:
            break
        }
    }
    
    public func cellTapped() {
        if !textField.isFirstResponder {
            textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
    }
}

extension AddRecordCell: UITextFieldDelegate { // MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        if newText.characters.count >= 10 {
            return false
        }
        
        if newText.characters.count == 0 {
            delegate?.propertyValueChanged(property: property, value: newText)
            return true
        }
        
        var should = true
        
        switch property.type {
        case .Int64:
            
            should = Int64(newText) != nil
            
            break
        case .Double:
            
            should = Double(newText) != nil
            
            break
        case .String:
            break
        default:
            break
        }
        
        if should {
            delegate?.propertyValueChanged(property: property, value: newText)
        }
        
        return should
    }
}
