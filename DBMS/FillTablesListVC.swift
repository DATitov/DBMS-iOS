//
//  FillTablesListVC.swift
//  DBMS
//
//  Created by Dmitrii Titov on 11.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class FillTablesListVC: BaseViewController {
    
    var viewModel : FillTablesListVM!
    
    @IBOutlet weak var navigationBarSimulator: NavigationBarSimulatorBase!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSimulator.title = NSLocalizedString("fill_tables_title", comment: "")
        tableView.register(TablesListEditingCell.self, forCellReuseIdentifier: "TablesListEditingCellIdentifier")
        navigationBarSimulator.backButtonPressedAction = {
            DispatchQueue.main.async { [unowned self] in
                _ = self.navigationController?.popViewController(animated: true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.relaunch()
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
    
}

extension FillTablesListVC: UITableViewDelegate { // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel.cellModel(index: indexPath.row)
        DataBaseRouter.shared.showFillTableScreen(dbFramework: viewModel.dbFramework, tableName: model.titleText)
    }
    
}

extension FillTablesListVC: UITableViewDataSource { // MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfTables()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TablesListEditingCellIdentifier", for: indexPath) as! TablesListEditingCell
        let row = indexPath.row
        cell.update(model: viewModel.cellModel(index: row))
        return cell
    }
    
}
