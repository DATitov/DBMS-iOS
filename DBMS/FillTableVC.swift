//
//  FillTableVC.swift
//  DBMS
//
//  Created by Dmitrii Titov on 12.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class FillTableVC: BaseViewController {

    @IBOutlet weak var navigationBarSimulator: NBSimulatorListEditing!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let recordTVCellIdentifier = "RecordTVCellIdentifier"
    
    var rowHeight = 40.0 as CGFloat
    
    var viewModel: FillTableVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(RecordTVCell.self, forCellReuseIdentifier: recordTVCellIdentifier)
        rowHeight = RecordTVCell.requiredHeight(forTable: viewModel.table)
        navigationBarSimulator.backButtonPressedAction = {
            DispatchQueue.main.async { [unowned self] in
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        navigationBarSimulator.title = viewModel.table.name
        navigationBarSimulator.addButtonPressedAction = {
            DispatchQueue.main.async { [unowned self] in
                DataBaseRouter.shared.showRecordScreen(dbFramework: self.viewModel.dbFramework, tableName: self.viewModel.table.name, record: nil, cancelAction: {
                    
                },
                                                       saveAction: {
                                                        DispatchQueue.main.async {
                                                            self.viewModel.relaunch()
                                                            self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
                                                        }
                })
            }
        }
        navigationBarSimulator.backgroundLayerView.backgroundColor = CommonCollorsStorage.navigationBarBackgroundColor()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let nbHeight = 54.0 as CGFloat
        navigationBarSimulator.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: nbHeight)
        tableView.frame = CGRect(x: 0, y: nbHeight, width: view.frame.size.width, height: view.frame.size.height - nbHeight)
    }
    
}

extension FillTableVC: UITableViewDelegate { // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension FillTableVC: UITableViewDataSource { // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRecords()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: recordTVCellIdentifier) as! RecordTVCell
        cell.update(withEntity: viewModel.table)
        cell.update(record: viewModel.recordModel(forIndex: indexPath.row))
        return cell
    }
    
}


