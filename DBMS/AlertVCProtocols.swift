
//
//  AlertVCProtocols.swift
//  DBMS
//
//  Created by Dmitrii Titov on 13.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import Foundation

protocol AlertViewProtocol {
    
    func keyboardWillAppear()
    func keyboardAppeared()
    
    func alertWillBeSqueezed()
    func alertWillBeExpanded()
    
}
