//
//  DataBaseVController.swift
//  DBMS
//
//  Created by Dmitrii Titov on 17.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

class DataBaseVController: BaseViewController {
    
    var viewModel : DataBaseVM!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBarSimulator: NavigationBarSimulatorBase!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.dataBaseFramework.rawValue
        navigationController?.setNavigationBarHidden(true, animated: true)
        tableView.register(UINib(nibName: "DataBaseActionTVCell", bundle: nil), forCellReuseIdentifier: "DataBaseActionTVCell")
        navigationBarSimulator.title = viewModel.dataBaseFramework.rawValue
        navigationBarSimulator.backButtonPressedAction = {
            DataBaseRouter.shared.moveToSelectionDataBaseScenario()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let nbHeight = 54.0 as CGFloat
        navigationBarSimulator.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: nbHeight)
        tableView.frame = CGRect(x: 0, y: nbHeight, width: view.frame.size.width, height: view.frame.size.height - nbHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.delaysContentTouches = false
    }
    
}

extension DataBaseVController: UITableViewDelegate { // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            DataBaseRouter.shared.showRequestsListScreen(dbFramework: viewModel.dataBaseFramework)
            break
        case 1:
            DataBaseRouter.shared.showFillingTablesListScreen(dbFramework: viewModel.dataBaseFramework)
            break
        case 2:
            DataBaseRouter.shared.showEditTablesListScreen(dbFramework: viewModel.dataBaseFramework)
            break
        default:
            break
        }
    }
    
}

extension DataBaseVController: UITableViewDataSource { // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataBasesManager.shared.dataBaseEditingEnabled(dbFramework: viewModel.dataBaseFramework) ? 3 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataBaseActionTVCell", for: indexPath) as! DataBaseActionTVCell
        
        switch indexPath.row {
        case 0:
            cell.label.text = NSLocalizedString("Requests", comment: "")
            break
        case 1:
            cell.label.text = NSLocalizedString("fill_db", comment: "")
            break
        case 2:
            cell.label.text = NSLocalizedString("configure_tables", comment: "")
            break
        default:
            break
        }
        
        return cell
    }
    
}
