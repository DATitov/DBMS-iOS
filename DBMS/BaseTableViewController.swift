//
//  BaseTableViewController.swift
//  DBMS
//
//  Created by Dmitrii Titov on 17.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        view.backgroundColor = CommonCollorsStorage.vcBackgroundColor()
    }

}
