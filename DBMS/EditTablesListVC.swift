//
//  EditTablesListVC.swift
//  DBMS
//
//  Created by Dmitrii Titov on 13.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class EditTablesListVC: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    fileprivate let headerReuseIdentifier = "headerReuseIdentifier"
    
    let editingState = Variable<Bool>(false)
    
    @IBOutlet weak var navigationBarSimulator: NBSimulatorListEditing!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel : EditTablesListVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.initBindings()
        navigationBarSimulator.backgroundLayerView.backgroundColor = CommonCollorsStorage.navigationBarBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.relaunch()
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        if navigationBarSimulator.isEditing.value {
            navigationBarSimulator.setEditing(editing: false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let nbHeight = 54.0 as CGFloat
        navigationBarSimulator.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: nbHeight)
        tableView.frame = CGRect(x: 0, y: nbHeight, width: view.frame.size.width, height: view.frame.size.height - nbHeight)
    }
    
    func setupUI() {
        self.setupNB()
        self.setupTV()
    }
    
    func setupNB() {
        navigationBarSimulator.title = NSLocalizedString("configure_tables", comment: "")
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        navigationBarSimulator.backButtonPressedAction = {
            self.backButtonPressed()
        }
        navigationBarSimulator.addButtonPressedAction = {
            DispatchQueue.main.async { [unowned self] in
                self.createButtonPressed()
            }
        }
    }
    
    func setupTV() {
        tableView.register(TablesListEditingCell.self, forCellReuseIdentifier: "TablesListEditingCellIdentifier")
        tableView.register(UINib.init(nibName: "RelationshipTVCell", bundle: nil), forCellReuseIdentifier: "RelationshipTVCell")
        tableView.register(OneLabelTVHeader.self, forHeaderFooterViewReuseIdentifier: "OneLabelTVHeader")
        tableView.contentInset = .zero
        tableView.register(TablesEditingListHeaderView.self, forHeaderFooterViewReuseIdentifier: headerReuseIdentifier)
        tableView.scrollIndicatorInsets = .zero
        tableView.backgroundColor = UIColor.clear
    }
    
    func initBindings() {
        _ = navigationBarSimulator.isEditing.asObservable()
            .distinctUntilChanged()
            .bindTo(editingState)
            .disposed(by: disposeBag)
        
        _ = editingState.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe { (editing) in
                self.viewModel.updateEditing(editing: editing.element!)
                self.tableView.setEditing(editing.element!, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}

extension EditTablesListVC: UITableViewDelegate { // MARK: UITableViewDelegate // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.editingState.value {
            self.viewModel.switchSelection(index: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .none)
        }else{
            if indexPath.section == 0 {
                let cellModel = viewModel.tableCellModel(index: indexPath.row)
                DataBaseRouter.shared.showEditTableScreen(dbFramework: viewModel.dbFramework, tableName: cellModel.titleText)
            }else{
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.numberOfTables() > 1 ? 50 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "OneLabelTVHeader") as! OneLabelTVHeader
        header.update(title: section == 0 ? NSLocalizedString("tables", comment: "") : NSLocalizedString("relationships", comment: ""))
        return header
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                viewModel.removeTable(atIndex: indexPath.row)
            }else{
                viewModel.removeRelationship(atIndex: indexPath.row)
            }
            viewModel.relaunch()
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
}

extension EditTablesListVC: UITableViewDataSource { // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.viewModel.numberOfTables()
        }else{
            return self.viewModel.numberOfReferences()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TablesListEditingCellIdentifier", for: indexPath) as! TablesListEditingCell
            cell.update(model: viewModel.tableCellModel(index: row))
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RelationshipTVCell", for: indexPath) as! RelationshipTVCell
            cell.update(model: viewModel.relationshipCellModel(index: row))
            return cell
        }
    }
    
}

extension EditTablesListVC { //  MARK: Actions
    
    func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func createButtonPressed() {
        if viewModel.numberOfTables() > 1 {
            let alert = UIAlertController(title: NSLocalizedString("create", comment: "") + ":", message: NSLocalizedString("what_to_create", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("table", comment: ""), style: .default, handler: { (action) -> Void in
                DispatchQueue.main.async { [weak self] in
                    self?.showCreateTableAlert()
                }
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("relationship", comment: ""), style: .default, handler: { (action) -> Void in
                DispatchQueue.main.async { [weak self] in
                    self?.showRelationshipVC(relationship: nil)
                }
                
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }else{
            self.showCreateTableAlert()
        }
    }
    
    func showCreateTableAlert() {
        let alert = UIAlertController(title: NSLocalizedString("new_table_alert_title", comment: ""), message:
            NSLocalizedString("new_table_alert_message", comment: ""), preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("table_name", comment: "")
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { [weak alert] (action) -> Void in
            alert?.dismiss(animated: true, completion: { })
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { [weak alert] (action) -> Void in
            let textField = (alert?.textFields![0])! as UITextField
            DispatchQueue.main.async {
                [unowned self] in
                if DataManagerAPI.shared.getAllTablesNames(dbFramework: self.viewModel.dbFramework).contains(textField.text!) {
                    self.showErrorAlert(message: NSLocalizedString("name_is_already_used", comment: ""))
                }else{
                    DataBaseRouter.shared.showEditTableScreen(dbFramework: self.viewModel.dbFramework, tableName: textField.text!)
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showRelationshipVC(relationship: TablesRelationship?) {
        DataBaseRouter.shared.showEditRelationshipScreen(dbFramework: viewModel.dbFramework, relationship: relationship)
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("continue", comment: ""), style: .default, handler: { [weak alert] (action) -> Void in
            DispatchQueue.main.async {
                alert?.dismiss(animated: true, completion: {
                    
                })
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
