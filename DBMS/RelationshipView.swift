//
//  RelationshipView.swift
//  DBMS
//
//  Created by Dmitrii Titov on 18.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import DTAlertViewContainer

class RelationshipView: UIView {
    
    let side1View = RelationshipSideView()
    let side2View = RelationshipSideView()
    
    let cancelButton = AlertViewButton()
    let saveButton = AlertViewButton()
    
    weak var delegate: DTAlertViewContainerProtocol?
    
    var requiredHeight = 0.0 as CGFloat
    var frameToFocus = CGRect.zero
    var needToFocus = false
        
    let relationshipTypeView = TablesRelationshipTypeView()
    
    var viewModel: RelationshipViewVM!
    
    var cancelButtonPressedAction: (() -> ())?
    var saveButtonPressedAction: (() -> ())?
    
    init(viewModel: RelationshipViewVM) {
        super.init(frame: .zero)
        self.setupUI()
        self.bindViewModel(viewModel: viewModel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    func setupUI() {
        self.addSubview(side1View)
        self.addSubview(side2View)
        self.addSubview(relationshipTypeView)
        backgroundColor = UIColor.clear
        
        self.setupButtons()
        
        self.requiredHeight = self.calculateRequiredHeight()
    }
    
    func setupButtons() {
        cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        saveButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        for button in [cancelButton, saveButton] {
            self.addSubview(button)
        }
        cancelButton.addTarget(self, action: #selector(self.cancelButtonPressed), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(self.saveButtonPressed), for: .touchUpInside)
    }
    
    func bindViewModel(viewModel: RelationshipViewVM) {
        self.viewModel = viewModel
        side1View.bindViewModel(viewModel: viewModel.relationshipSide1ViewModel)
        side2View.bindViewModel(viewModel: viewModel.relationshipSide2ViewModel)
        relationshipTypeView.bindViewModel(viewModel: viewModel.relationshipTypeViewViewModel)
    }
    
}

extension RelationshipView {
    
    private func verticalSpaces() -> (verticalOffset: CGFloat, sideViewHeight: CGFloat, betweenVerticalSpace: CGFloat, relationTypeViewHeight: CGFloat, buttonsHeight: CGFloat) {
        let verticalOffset = 0.0 as CGFloat
        let relationTypeViewHeight = 40.0 * 2 as CGFloat
        let betweenVerticalSpace = 5.0 as CGFloat
        let sideViewHeight = RelationshipSideView.requiredHeight()//(self.frame.size.height - (verticalOffset + betweenVerticalSpace) * 2 - countViewHeight) / 2.0
        return (verticalOffset: verticalOffset,
                sideViewHeight: sideViewHeight,
                betweenVerticalSpace: betweenVerticalSpace,
                relationTypeViewHeight: relationTypeViewHeight,
                buttonsHeight: 30.0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let verticalSpaces = self.verticalSpaces()
        
        let horisontalOffset = 0.0 as CGFloat
        let verticalOffset = verticalSpaces.verticalOffset
        let betweenVerticalSpace = verticalSpaces.betweenVerticalSpace
        
        let relationshipTypeViewSize = CGSize(width: self.frame.size.width - 2 * horisontalOffset, height: verticalSpaces.relationTypeViewHeight)
        let sideViewSize = CGSize(width: self.frame.size.width - 2 * horisontalOffset,
                                  height: verticalSpaces.sideViewHeight )
        side1View.frame = CGRect(x: horisontalOffset, y: verticalOffset, width: sideViewSize.width, height: sideViewSize.height)
        relationshipTypeView.frame = CGRect(x: horisontalOffset, y: verticalOffset + sideViewSize.height + betweenVerticalSpace,
                                            width: relationshipTypeViewSize.width, height: relationshipTypeViewSize.height)
        side2View.frame = CGRect(x: horisontalOffset, y: verticalOffset + sideViewSize.height + betweenVerticalSpace * 2 + relationshipTypeViewSize.height,
                                 width: sideViewSize.width, height: sideViewSize.height)
        
        let buttonsSize = CGSize(width: self.frame.size.width * 2 / 5, height: verticalSpaces.buttonsHeight)
        let buttonsYCoord = horisontalOffset + sideViewSize.height * 2 + relationshipTypeViewSize.height + betweenVerticalSpace * 3
        let buttonsHorisontalOffset = horisontalOffset + 4.0
        cancelButton.frame = CGRect(x: buttonsHorisontalOffset, y: buttonsYCoord,
                                    width: buttonsSize.width, height: buttonsSize.height)
        saveButton.frame = CGRect(x: self.frame.size.width - buttonsSize.width - buttonsHorisontalOffset, y: buttonsYCoord,
                                  width: buttonsSize.width, height: buttonsSize.height)
        
    }
    
    func calculateRequiredHeight() -> CGFloat {
        let verticalSpaces = self.verticalSpaces()
        return (verticalSpaces.verticalOffset + verticalSpaces.sideViewHeight) * 2 + verticalSpaces.betweenVerticalSpace * 3 + verticalSpaces.relationTypeViewHeight + verticalSpaces.buttonsHeight
    }
    
}

extension RelationshipView: DTAlertViewProtocol {
    
    func backgroundPressed() {
        
    }
    
}

extension RelationshipView {
    
    @objc func cancelButtonPressed() {
        if cancelButtonPressedAction != nil {
            self.cancelButtonPressedAction!()
        }
        delegate?.dismiss()
    }
    
    @objc func saveButtonPressed() {
        let relationship = viewModel.constructRelationship()
        viewModel.saveRelationship(relationship: relationship)
        if saveButtonPressedAction != nil {
            self.saveButtonPressedAction!()
        }
        delegate?.dismiss()
    }
}
