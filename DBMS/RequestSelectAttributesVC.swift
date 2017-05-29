//
//  RequestSelectAttributesVC.swift
//  DBMS
//
//  Created by Dmitrii Titov on 22.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class RequestSelectAttributesVC: BaseViewController {
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var navigationBarSimulator: NBSimulatorSelection!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: RequestSelectAttributesVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarSimulator.title = NSLocalizedString("request_selection_attributes", comment: "")
        navigationBarSimulator.backButtonPressedAction = {
            self.backButtonPressed()
        }
        navigationBarSimulator.selectButtonPressedAction = {
            self.selectButtonPressed()
        }
        navigationBarSimulator.backgroundLayerView.backgroundColor = CommonCollorsStorage.navigationBarBackgroundColor()
        tableView.register(TwoLabelTVCell.self, forCellReuseIdentifier: "TwoLabelTVCell")
        
        self.initBidings()
        
        let indexPathsToSelect = viewModel.indexPathsForSelectedItems()
        for path in indexPathsToSelect {
            tableView.selectRow(at: path, animated: true, scrollPosition: .top)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let nbHeight = 54.0 as CGFloat
        navigationBarSimulator.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: nbHeight)
        tableView.frame = CGRect(x: 0, y: nbHeight, width: view.frame.size.width, height: view.frame.size.height - nbHeight)
    }
    
    func initBidings() {
        
        viewModel.availableItems.asObservable()
            .bindTo(self.tableView.rx.items(cellIdentifier: "TwoLabelTVCell", cellType: TwoLabelTVCell.self)) { (row, model, cell) in
                cell.update(text1: model.requestName, text2: model.attributeName)
                cell.selectionStyle = .gray
            }
            .disposed(by: disposeBag)
        
    }
    
}

extension RequestSelectAttributesVC: UITableViewDelegate { // MARK: UITableViewDelegate
    
}


extension RequestSelectAttributesVC { // MARK: Actions
    
    func backButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func selectButtonPressed() {
        guard let selectedPaths = tableView.indexPathsForSelectedRows else {
            viewModel.selectButtonPressed(indexPaths: [])
            _ = navigationController?.popViewController(animated: true)
            return
        }
        viewModel.selectButtonPressed(indexPaths: selectedPaths)
        _ = navigationController?.popViewController(animated: true)
    }
    
}
