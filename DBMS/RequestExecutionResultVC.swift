//
//  RequestExecutionResultVC.swift
//  DBMS
//
//  Created by Dmitrii Titov on 24.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class RequestExecutionResultVC: BaseViewController {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var navigationBarSimulator: NavigationBarSimulatorBase!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: RequestExecutionResultVM!
    var rowHeight = 40.0 as CGFloat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSimulator.backgroundLayerView.backgroundColor = CommonCollorsStorage.navigationBarBackgroundColor()
        viewModel.relaunch()
        self.setupUI()
        self.initBindings()
    }
    
    func setupUI() {
        navigationBarSimulator.title = viewModel.request.value.name
        navigationBarSimulator.backButtonPressedAction = {
            DispatchQueue.main.async {
                self.backButtonPressed()
            }
        }
        tableView.register(RecordTVCell.self, forCellReuseIdentifier: "RecordTVCell")
        
        rowHeight = RecordTVCell.requiredHeight(forTable: viewModel.table)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let nbHeight = 54.0 as CGFloat
        navigationBarSimulator.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: nbHeight)
        tableView.frame = CGRect(x: 0, y: nbHeight, width: view.frame.size.width, height: view.frame.size.height - nbHeight)
    }
    
    func initBindings() {
        viewModel.cellsModels.asObservable()
            .bindTo(self.tableView.rx.items(cellIdentifier: "RecordTVCell", cellType: RecordTVCell.self)) { (row, model, cell) in
                cell.update(withEntity: self.viewModel.table)
                cell.update(record: self.viewModel.cellModel(forIndex: row))
            }
            .disposed(by: disposeBag)
        
    }
    
}

extension RequestExecutionResultVC: UITableViewDelegate { // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
}

extension RequestExecutionResultVC { // MARK: Actions
    
    func backButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
}
