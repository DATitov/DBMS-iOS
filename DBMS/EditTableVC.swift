//
//  EditTableVC.swift
//  DBMS
//
//  Created by Dmitrii Titov on 22.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class EditTableVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var viewModel : EditTableVM!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBarSimulator: NBSimulatorObjectEditing!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.initBindings()
        navigationBarSimulator.backgroundLayerView.backgroundColor = CommonCollorsStorage.navigationBarBackgroundColor()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.editingState.value = false
        viewModel.relaunch(tableName: viewModel.table.name)
        tableView.reloadData()
        if navigationBarSimulator.isEditing.value {
            navigationBarSimulator.setEditing(editing: false)
        }
    }
    
    private func configureView() {
        navigationBarSimulator.title = self.viewModel.table.name
        navigationBarSimulator.titleTextField.text = self.viewModel.table.name
        navigationBarSimulator.backButtonPressedAction = {
            DispatchQueue.main.async {
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        navigationBarSimulator.addButtonPressedAction = {
            DispatchQueue.main.async { [unowned self] in
                self.addColumnDialog()
            }
        }
        navigationBarSimulator.removeButtonPressedAction = {
            DispatchQueue.main.async { [unowned self] in
                _ = self.viewModel.dropTable()
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
        tableView.register(AttributeEditingTVCell.self, forCellReuseIdentifier: "AttributeEditingTVCell")
        tableView.register(RemoveButtonTVCell.self, forCellReuseIdentifier: "RemoveButtonTVCell")
    }
    
    
    func initBindings() {
        
        _ = navigationBarSimulator.isEditing.asObservable()
            .distinctUntilChanged()
            .bindTo(viewModel.editingState)
            .disposed(by: disposeBag)
        
        _ = viewModel.editingState.asObservable()
            .skip(1)
            .subscribeOn(MainScheduler.instance)
            .subscribe { (editing) in
                self.tableView.setEditing(editing.element!, animated: true)
                UIView.animate(withDuration: 0.2,
                               animations: {
                                self.layoutViews()
                })
            }
            .disposed(by: disposeBag)
        
        _ = navigationBarSimulator.nameTempleText.asObservable()
            .skip(1)
            .map { [weak self] (text) -> (String, Bool) in
                if text.uppercased() == self?.viewModel.table.name.uppercased() {
                    return ("Equal to existing name", true)
                }else if (self?.viewModel.tableNameAvailable(name: text))! {
                    return ("Name available", true)
                }else{
                    return ("Table with equal name exist", false)
                }
            }.bindTo(navigationBarSimulator.info)
            .disposed(by: disposeBag)
        
        
        _ = navigationBarSimulator.name.asObservable()
            .skip(1)
            .subscribe({ [weak self] (event) in
                _ = self?.viewModel.renameTable(newName: event.element!)
            })
            .disposed(by: disposeBag)
        
    }
    
    func addColumnDialog() {
        
        let alert = UIAlertController(title: NSLocalizedString("new_attribute_alert_title", comment: ""),
                                      message: NSLocalizedString("new_attribute_alert_message", comment: ""), preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("attribute_name", comment: "")
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { [weak alert] (action) -> Void in
            alert?.dismiss(animated: true, completion: {
                
            })
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { [weak alert] (action) -> Void in
            let textField = (alert?.textFields![0])! as UITextField
            
            DispatchQueue.main.async {
                let newAttribute = TableProperty(name: textField.text!, type: .String)
                var error: Error?
                let tableExist = AppDBChecker.shared.checkTableExist(dbFramework: self.viewModel.dbFramework, name: self.viewModel.table.name)
                if tableExist {
                    DataManagerAPI.shared.addColumn(dbFramework: self.viewModel.dbFramework, tableName: self.viewModel.table.name, attribute: newAttribute, error: &error)
                }else{
                    self.viewModel.table.properties.append(newAttribute)
                    DataManagerAPI.shared.createTable(dbFramework: self.viewModel.dbFramework, table: self.viewModel.table, error: &error)
                }
                if error == nil {
                    DataBaseRouter.shared.showColumnScreen(dbFramework: self.viewModel.dbFramework, tableName: self.viewModel.table.name, columnName: textField.text!)
                }else{
                    print()
                }
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layoutViews()
    }
    
    func layoutViews() {
        let nbHeight = (navigationBarSimulator.isEditing.value ? 88 : 54) as CGFloat
        navigationBarSimulator.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: nbHeight)
        tableView.frame = CGRect(x: 0, y: nbHeight, width: view.frame.size.width, height: view.frame.size.height - nbHeight)
    }
    
}

extension EditTableVC: UITableViewDelegate { // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellModel = viewModel.cellModel(index: indexPath.row)
        DataBaseRouter.shared.showColumnScreen(dbFramework: viewModel.dbFramework, tableName: viewModel.table.name, columnName: cellModel.titleText)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if viewModel.editingState.value {
                if indexPath.row == 0 {
                    return 60
                }else{
                    return NameEditingTVCell.requiredHeight(short: false)
                }
            }else{
                return NameEditingTVCell.requiredHeight(short: true)
            }
        }else{
            if indexPath.row < viewModel.getNumberOfModels() {
                return 100
            }else{
                return 224
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeAttribute(index: indexPath.row)
            viewModel.relaunch(tableName: viewModel.table.name)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
}

extension EditTableVC: UITableViewDataSource { // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfModels()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeEditingTVCell", for: indexPath) as! AttributeEditingTVCell
        let model = viewModel.cellModel(index: indexPath.row)
        cell.updateAttributeEditingTVCell(model: model)
        //cell.update(name: self.viewModel.getColumnName(index: row), type: self.viewModel.getColumnType(index: row))
        return cell
    }
}
