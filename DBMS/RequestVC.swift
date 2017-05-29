 //
 //  RequestVC.swift
 //  DBMS
 //
 //  Created by Dmitrii Titov on 20.05.17.
 //  Copyright © 2017 Dmitrii Titov. All rights reserved.
 //
 
 import UIKit
 import RxSwift
 
 class RequestVC: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var navigationBarSimulator: NBSimulatorObjectEditing!
    @IBOutlet weak var tableView: UITableView!
    
    let tableNameCell = NameEditingTVCell()
    let executeButtonTVCell: EnterButtonTVCell = {
        let cell = EnterButtonTVCell()
        cell.buttonTitle = NSLocalizedString("execute", comment: "")
        return cell
    }()
    
    var viewModel: RequestVM!
    
    let editingState = Variable<Bool>(false)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(TwoLabelTVCell.self, forCellReuseIdentifier: "TwoLabelTVCell")
        tableView.register(RequestSourceTVCell.self, forCellReuseIdentifier: "RequestSourceTVCell")
        tableView.register(RequestConditionItemTVCell.self, forCellReuseIdentifier: "RequestConditionItemTVCell")
        tableView.register(OneLabelTVHeader.self, forHeaderFooterViewReuseIdentifier: "OneLabelTVHeader")
        
        navigationBarSimulator.title = viewModel.requestName
        navigationBarSimulator.titleTextField.text = viewModel.requestName
        navigationBarSimulator.backButtonPressedAction = {
            DispatchQueue.main.async {
                self.backButtonPressed()
            }
        }
        navigationBarSimulator.addButtonPressedAction = {
            DispatchQueue.main.async {
                self.addButtonPressed()
            }
        }
        navigationBarSimulator.removeButtonPressedAction = {
            DispatchQueue.main.async {
                DataManagerAPI.shared.removeRequest(request: self.viewModel.request.value)
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        navigationBarSimulator.backgroundLayerView.backgroundColor = CommonCollorsStorage.navigationBarBackgroundColor()
        
        executeButtonTVCell.delegate = self
        self.initBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.relaunch()
        if navigationBarSimulator.isEditing.value {
            navigationBarSimulator.setEditing(editing: false)
        }
    }
    
    func initBindings() {
        
        _ = Observable.combineLatest(viewModel.selectedItems.asObservable(),
                                     viewModel.source.asObservable(),
                                     viewModel.conditionsItemsModels.asObservable(),
                                     resultSelector: { (_) -> Void in
                                        return
        })
            .subscribe(onNext: { () in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        
        _ = navigationBarSimulator.isEditing.asObservable()
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bindTo(editingState)
            .disposed(by: disposeBag)
        
        _ = editingState.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe { (editing) in
                self.tableView.setEditing(editing.element!, animated: true)
                UIView.animate(withDuration: 0.2,
                               animations: {
                                self.layoutViews()
                })
            }
            .disposed(by: disposeBag)
        
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
 
 extension RequestVC: UITableViewDelegate { // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 || indexPath.section == 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 3 ? 0 : 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return self.heightForExecuteButtonCell()
        }else{
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "OneLabelTVHeader") as! OneLabelTVHeader
        switch section {
        case 0:
            header.update(title: NSLocalizedString("request_selection_items", comment: ""))
            break
        case 1:
            header.update(title: NSLocalizedString("request_from", comment: ""))
            break
        case 2:
            header.update(title: NSLocalizedString("request_conditions", comment: ""))
            break
        default:
            break
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            return
        case 1:
            guard let source = viewModel.request.value.source else {
                return
            }
            DataBaseRouter.shared.showRequestSourcesSelectionScreen(dbFramework: viewModel.dbFramework, requestSource: source,
                                                                    requestsNamesToSkip: [viewModel.request.value.name], selectionAction: { source in
                                                                        DataManagerAPI.shared.updateSource(dbFramework: self.viewModel.dbFramework, request: self.viewModel.request.value, source: source)
                                                                        self.viewModel.relaunch()
            })
            return
        case 2:
            let conditionItem = viewModel.conditionsItems.value[indexPath.row]
            DataBaseRouter.shared.showRequestEditConditionScreen(dbFramework: self.viewModel.dbFramework,
                                                                 conditionItem: conditionItem,
                                                                 availableSelectionItems: self.viewModel.availableSelectionItems.value)
            return
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        print()
        if editingStyle == .delete {
            viewModel.removeConditionItem(atIndex: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        switch indexPath.section {
        case 0:
            return UITableViewCellEditingStyle.none
        case 1:
            return UITableViewCellEditingStyle.none
        case 2:
            return UITableViewCellEditingStyle.delete
        default:
            return UITableViewCellEditingStyle.none
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 2
    }
    
 }
 
 extension RequestVC: UITableViewDataSource { // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.selectedItems.value.count
        case 1:
            return 1
        case 2:
            return viewModel.conditionsItemsModels.value.count
        case 3:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TwoLabelTVCell") as! TwoLabelTVCell
            let model = viewModel.selectionItemModel(forIndex: indexPath.row)
            cell.update(text1: model.requestName, text2: model.attributeName)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestSourceTVCell") as! RequestSourceTVCell
            let model = viewModel.source.value
            cell.update(model: model)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "RequestConditionItemTVCell") as! RequestConditionItemTVCell
            let model = viewModel.conditionItemModel(forIndex: indexPath.row)
            cell.update(model: model)
            return cell
        case 3:
            return executeButtonTVCell
        default:
            return UITableViewCell(style: .default, reuseIdentifier: "Empty")
        }
    }
 }
 
 extension RequestVC { // MARK: Actions
    
    func backButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func addButtonPressed() {
        let alert = UIAlertController(title: NSLocalizedString("add", comment: ""), message: NSLocalizedString("what_to_add", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("request_add_selection", comment: ""), style: .default, handler: { (action) -> Void in
            DispatchQueue.main.async { [unowned self] in
                DataBaseRouter.shared.showRequestSelectAttributesScreen(dbFramework: self.viewModel.dbFramework,
                                                                        selectedItems: self.viewModel.selectedItems.value,
                                                                        availableItems: self.viewModel.availableSelectionItems.value,
                                                                        selectionAction: { (items) in
                                                                            self.viewModel.pushSelectedItems(items: items)
                })
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("request_add_conditions", comment: ""), style: .default, handler: { (action) -> Void in
            DispatchQueue.main.async { [unowned self] in
                let conditionItem = RequestConditionItem()
                let selectionItem = RequestSelectionItem()
                conditionItem.selectedItem = selectionItem
                DataManagerAPI.shared.addCondition(request: self.viewModel.request.value, conditionItem: conditionItem)
                DataManagerAPI.shared.conditionUpdateSelectionItem(conditionItem: conditionItem, selectedItem: selectionItem)
                self.viewModel.relaunch()
                DataBaseRouter.shared.showRequestEditConditionScreen(dbFramework: self.viewModel.dbFramework,
                                                                     conditionItem: conditionItem,
                                                                     availableSelectionItems: self.viewModel.availableSelectionItems.value)
            }
            
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
 }
 
 extension RequestVC: EnterButtonTVCellDelegate {
    
    func buttonPressed() {
        DataBaseRouter.shared.showRequestExecutionResultScreen(dbFramework: viewModel.dbFramework, requestName: viewModel.request.value.name)
    }
    
 }
 
 extension RequestVC { // MARK: Calculations
    
    func heightForExecuteButtonCell() -> CGFloat {
        let tvHeight = tableView.frame.size.height
        let defaultHeight = 80.0 as CGFloat
        guard let dataSource = tableView.dataSource, let delegate = tableView.delegate else {
            return defaultHeight
        }
        let contentHeight = { () -> CGFloat in
            var contentHeight = 0.0 as CGFloat
            for section in 0..<dataSource.numberOfSections!(in: tableView) - 1 {
                contentHeight += delegate.tableView!(tableView, heightForHeaderInSection: section)
                for row in 0..<dataSource.tableView(tableView, numberOfRowsInSection: section) {
                    contentHeight += (tableView.delegate?.tableView!(tableView, heightForRowAt: IndexPath(row: row, section: section)))!
                }
            }
            return contentHeight
        }()
        return max(defaultHeight, tvHeight - contentHeight)
    }
    
 }
 
