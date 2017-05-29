//
//  EditRelationshipVC.swift
//  DBMS
//
//  Created by Dmitrii Titov on 18.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class EditRelationshipVC: BaseViewController {

    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var relationshipView: RelationshipView!
    
    var viewModel: EditRelationshipVM!
    
    var cancelButtonPressedAction: (() -> ())?
    var saveButtonPressedAction: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        relationshipView.bindViewModel(viewModel: RelationshipViewVM(dbFramework: viewModel.dbFramework, relationship: viewModel.relationship))
        relationshipView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let requiredHeight = relationshipView.requiredHeight()
        let horisontalOffset = 20.0 as CGFloat
        let size = CGSize(width: view.frame.size.width - horisontalOffset * 2, height: requiredHeight)
        relationshipView.frame = CGRect(x: horisontalOffset, y: (view.frame.size.height - size.height) / 2,
                                        width: size.width, height: size.height)
    }
    
}

extension EditRelationshipVC: AlertViewDelegate {
    
    func cancelButtonPressed() {
        guard cancelButtonPressedAction != nil else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveButtonPressed(object: AnyObject) {
        guard object.isKind(of: TablesRelationship.self) else {
            return
        }
        DataManagerAPI.shared.addRelationship(dbFramework: viewModel.dbFramework, relationship: object as! TablesRelationship)
        guard saveButtonPressedAction != nil else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.saveButtonPressedAction!()
        self.dismiss(animated: true, completion: nil)
    }
    
}
