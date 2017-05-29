//
//  RequestsListVC.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RequestsListVC: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var navigationBarSimulator: NBSimulatorListEditing!
    @IBOutlet weak var tableView: UITableView!
    
    let editingState = Variable<Bool>(false)
    
    var viewModel: RequestsListVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(RequestTVCell.self, forCellReuseIdentifier: "RequestTVCell")
        navigationBarSimulator.title = NSLocalizedString("Requests", comment: "") 
        navigationBarSimulator.backButtonPressedAction = {
            self.backButtonPressed()
        }
        navigationBarSimulator.addButtonPressedAction = {
            DispatchQueue.main.async {
                self.showCreateRequestAlert()
            }
        }
        self.initBindings()
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
        if navigationBarSimulator.isEditing.value {
            navigationBarSimulator.setEditing(editing: false)
        }
    }
    
    func initBindings() {

        _ = viewModel.cellsModels.asObservable()
        .subscribeOn(MainScheduler.instance)
        .subscribe(onNext: { _ in
            self.tableView.reloadData()
        })
            .disposed(by: disposeBag)
        
        _ = navigationBarSimulator.isEditing.asObservable()
            .distinctUntilChanged()
            .bindTo(editingState)
            .disposed(by: disposeBag)
        
        _ = editingState.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe { (editing) in
                self.tableView.setEditing(editing.element!, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
    
}

extension RequestsListVC: UITableViewDelegate { // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return !tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let request = viewModel.requests.value[indexPath.row]
        DataBaseRouter.shared.showRequestVC(dbFramework: self.viewModel.dbFramework, requestName: request.name)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print()
        if editingStyle == .delete {
            if viewModel.removeRequest(atIndex: indexPath.row) {
                //tableView.deleteRows(at: [indexPath], with: .bottom)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
}

extension RequestsListVC: UITableViewDataSource { // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellsModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestTVCell") as! RequestTVCell
        let model = viewModel.cellsModels.value[indexPath.row]
        cell.update(model: model)
        return cell
    }
    
}

extension RequestsListVC { // MARK: Actions
    
    func backButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func showCreateRequestAlert() {
        let alert = UIAlertController(title: NSLocalizedString("new_request_alert_title", comment: ""),
                                      message: NSLocalizedString("new_request_alert_message", comment: ""), preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("request_name", comment: "")
        }
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: { [weak alert] (action) -> Void in
            alert?.dismiss(animated: true, completion: { })
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (action) -> Void in
            let textField = (alert?.textFields![0])! as UITextField
            DispatchQueue.main.async {
                [unowned self] in
                guard let request = self.viewModel.createNewRequest(name: textField.text!) else {
                    self.showNotificationAlert(title: NSLocalizedString("error", comment: ""),
                                               message: NSLocalizedString("name_is_not_valid", comment: ""),
                                               okButtonText: NSLocalizedString("ok", comment: ""))
                    return
                }
                DataBaseRouter.shared.showRequestVC(dbFramework: self.viewModel.dbFramework, requestName: request.name)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


/*
 
 viewModel.cellsModels.asObservable()
 .bindTo(self.tableView.rx.items(cellIdentifier: "RequestTVCell", cellType: RequestTVCell.self)) { (row, model, cell) in
 cell.update(model: model)
 }
 .disposed(by: disposeBag)
 */
