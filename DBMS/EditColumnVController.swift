//
//  EditColumnTVController.swift
//  DBMS
//
//  Created by Dmitrii Titov on 21.03.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class EditColumnVController: BaseViewController {
    
    let disposeBag = DisposeBag()
    
    var viewModel : EditColumnVM!
    
    @IBOutlet weak var tableView: UITableView!    
    @IBOutlet weak var navigationBarSimulator: NBSimulatorObjectEditing!
    
    let isUniqueCell: ColumnBoolPropertyTVCell = UINib.init(nibName: "ColumnBoolPropertyTVCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ColumnBoolPropertyTVCell
    let isPrimaryCell: ColumnBoolPropertyTVCell = UINib.init(nibName: "ColumnBoolPropertyTVCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ColumnBoolPropertyTVCell
    let isNullableCell: ColumnBoolPropertyTVCell = UINib.init(nibName: "ColumnBoolPropertyTVCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ColumnBoolPropertyTVCell
    let isForeignCell: ColumnBoolPropertyTVCell = UINib.init(nibName: "ColumnBoolPropertyTVCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ColumnBoolPropertyTVCell
    
    let dataTypeCell: DataTypeSelectionTVCell = UINib.init(nibName: "DataTypeSelectionTVCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DataTypeSelectionTVCell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.initBindins()
        
        navigationBarSimulator.title = viewModel.column.value.name
        navigationBarSimulator.backButtonPressedAction = {
            DispatchQueue.main.async { [weak self] in
                _ = self?.navigationController?.popViewController(animated: true)
            }
        }
        navigationBarSimulator.removeButtonPressedAction = {
            _ = self.viewModel.removeColumn()            
            _ = self.navigationController?.popViewController(animated: true)
            if self.viewModel.table.properties.count == 1 {
                _ = self.navigationController?.popViewController(animated: true)
            }

        }
        tableView.register(RemoveButtonTVCell.self, forCellReuseIdentifier: "RemoveButtonTVCell")
        dataTypeCell.viewModel = DataTypeSelectionCellVM(dataType: viewModel.column.value.type)
        navigationBarSimulator.titleTextField.placeholder = NSLocalizedString("attribute_name", comment: "")
        navigationBarSimulator.titleTextField.text = viewModel.column.value.name
        navigationBarSimulator.backgroundLayerView.backgroundColor = CommonCollorsStorage.navigationBarBackgroundColor()
    }
    
    func showErrorAlert(message: String) {
        let alert = UIAlertController(title: NSLocalizedString("error", comment: ""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("continue", comment: ""), style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func initBindins() {
        _ = navigationBarSimulator.isEditing.asObservable()
            .distinctUntilChanged()
            .bindTo(self.viewModel.editingState)
            .disposed(by: disposeBag)
        
        for cell in [isUniqueCell, isPrimaryCell, isNullableCell, isForeignCell] {
            _ = viewModel.editingState.asObservable()
                .bindTo(cell.isEditingState)
                .disposed(by: disposeBag)
        }
        
        _ = navigationBarSimulator.nameTempleText.asObservable()
            .skip(1)
            .map { [weak self] (text) -> (String, Bool) in
                if text.uppercased() == self?.viewModel.column.value.name.uppercased() {
                    return (NSLocalizedString("equal_to_existing_name", comment: ""), true)
                }else if (self?.viewModel.columnNameAvailable(name: text))! {
                    return (NSLocalizedString("name_available", comment: ""), true)
                }else{
                    return (NSLocalizedString("name_is_already_used", comment: ""), false)
                }
            }.bindTo(navigationBarSimulator.info)
            .disposed(by: disposeBag)
        
        
        _ = navigationBarSimulator.name.asObservable()
            .skip(1)
            .subscribe({ [weak self] (event) in
                _ = self?.viewModel.updateColumn(newName: event.element!, column: (self?.viewModel.column.value)!)
            })
            .disposed(by: disposeBag)
        
        _ = viewModel.editingState.asObservable()
            .bindTo(dataTypeCell.isEditingState)
            .disposed(by: disposeBag)
        
        
        _ = viewModel.editingState.asObservable()
            .skip(1)
            .subscribeOn(MainScheduler.instance)
            .subscribe { (editing) in
                UIView.animate(withDuration: 0.2,
                               animations: {
                                self.layoutViews()
                })
            }
            .disposed(by: disposeBag)
        
        _ = isPrimaryCell.userSwitchValue.asObservable()
            .bindTo(self.viewModel.isPrimary)
            .disposed(by: disposeBag)
        
        _ = isUniqueCell.userSwitchValue.asObservable()
            .bindTo(self.viewModel.isUnique)
            .disposed(by: disposeBag)
        
        _ = isNullableCell.userSwitchValue.asObservable()
            .bindTo(self.viewModel.isNullable)
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

extension EditColumnVController { // MARK: Setup UI
    
    func setupUI() {
        self.setupCells()
    }
    
    func setupCells() {
        isUniqueCell.update(propertyName: "Unique", value: viewModel.column.value.unique)
        isPrimaryCell.update(propertyName: "Primary", value: viewModel.column.value.primaryKey)
        isNullableCell.update(propertyName: "Nullable", value: viewModel.column.value.nullable)
        isForeignCell.update(propertyName: "Foreign", value: viewModel.column.value.foreighKey != nil)
    }
    
}

extension EditColumnVController: UITableViewDelegate { // MARK: UITableViewDelegate // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        _ = viewModel.removeColumn().asObservable()
            .subscribe(onError: { (error) in
                self.showErrorAlert(error: error)
            },
                       onCompleted: {
                        DispatchQueue.main.async { [unowned self] in
                            _ = self.navigationController?.popViewController(animated: true)
                            if self.viewModel.table.properties.count == 1 {
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                        }
            })
        .addDisposableTo(disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if viewModel.editingState.value {
                if indexPath.row == 0 {
                    return 60
                }else{
                    return NameEditingTVCell.requiredHeight(short: false)
                }
            }else{
                return NameEditingTVCell.requiredHeight(short: false)
            }
        case 1:
            return 100
        case 2:
            return 40
        case 3:
            return 120
        default:
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return viewModel.editingState.value && indexPath.section == 0 && indexPath.row == 0
    }
        
}

extension EditColumnVController: UITableViewDataSource { // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return dataTypeCell
        case 1:
            switch indexPath.row {
            case 0:
                isUniqueCell.switcher.setOn(viewModel.column.value.unique, animated: false)
                return isUniqueCell
            case 1:
                isPrimaryCell.switcher.setOn(viewModel.column.value.primaryKey, animated: false)
                return isPrimaryCell
            case 2:
                isNullableCell.switcher.setOn(viewModel.column.value.nullable, animated: false)
                return isNullableCell
            case 3:
                return isForeignCell
            default:
                return UITableViewCell(style: .default, reuseIdentifier: "identifier")
            }
        default:
            return UITableViewCell(style: .default, reuseIdentifier: "identifier")
        }
    }
    
}

