//
//  BaseViewController.swift
//  DBMS
//
//  Created by Dmitrii Titov on 17.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    func configureView() {
        self.view.backgroundColor = .white
    }
    
    func showNotificationAlert(title: String?, message: String?, okButtonText: String?) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: title ?? NSLocalizedString("error", comment: ""), message: message ?? "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: okButtonText ?? NSLocalizedString("ok", comment: ""), style: .default, handler: { [weak alert] (action) -> Void in
                DispatchQueue.main.async {
                    alert?.dismiss(animated: true, completion: {
                        
                    })
                }
            }))
            
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func showErrorAlert(error: Error) {
        self.showNotificationAlert(title: nil, message: error.localizedDescription, okButtonText: nil)
    }
    
}
