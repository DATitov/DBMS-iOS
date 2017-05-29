//
//  RequestSourcesSelectionVC.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

class RequestSourcesSelectionVC: BaseViewController {
    
    let disposeBag = DisposeBag()

    @IBOutlet weak var navigationBarSimulator: NBSimulatorSelection!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: RequestSourcesSelectionVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(OneLabelTVCell.self, forCellReuseIdentifier: "OneLabelTVCell")
        tableView.register(OneLabelTVHeader.self, forHeaderFooterViewReuseIdentifier: "OneLabelTVHeader")
        navigationBarSimulator.title = NSLocalizedString("request_sources_title", comment: "")
        navigationBarSimulator.backButtonPressedAction = {
            self.backButtonPressed()
        }
        navigationBarSimulator.selectButtonPressedAction = {
            self.selectButtonPressed()
        }
        navigationBarSimulator.backgroundLayerView.backgroundColor = CommonCollorsStorage.navigationBarBackgroundColor()
        
        let indexPathsToSelect = viewModel.indexPathsOfSelectedItems()
        for path in indexPathsToSelect {
            tableView.selectRow(at: path, animated: true, scrollPosition: .top)
        }
        
        self.initBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let nbHeight = 54.0 as CGFloat
        navigationBarSimulator.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: nbHeight)
        tableView.frame = CGRect(x: 0, y: nbHeight, width: view.frame.size.width, height: view.frame.size.height - nbHeight)
    }
    
    func initBindings() {
        
    }
    
}

extension RequestSourcesSelectionVC: UITableViewDelegate { // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let selectedRows = tableView.indexPathsForSelectedRows else {
            return true
        }
        for path in selectedRows {
            if path == indexPath {
                return true
            }
        }
        return (selectedRows.count) < 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header =  tableView.dequeueReusableHeaderFooterView(withIdentifier: "OneLabelTVHeader") as! OneLabelTVHeader
        switch section {
        case 0:
            header.update(title: NSLocalizedString("tables", comment: ""))
            break
        case 1:
            header.update(title: NSLocalizedString("requests", comment: ""))
            break
        default:
            break
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for path in selectedRows {
                if path == indexPath {
                    tableView.deselectRow(at: indexPath as IndexPath, animated: false)
                    return nil
                }
            }
        }
        return indexPath
    }
}

extension RequestSourcesSelectionVC: UITableViewDataSource { // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.sourceVariantsTablesRequests.value.count
        case 1:
            return viewModel.sourceVariantsRequests.value.count
        default:
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OneLabelTVCell") as! OneLabelTVCell
        switch indexPath.section {
        case 0:
            cell.update(text: viewModel.tableRequestName(forIndex: indexPath.row))
            break
        case 1:
            cell.update(text: viewModel.requestName(forIndex: indexPath.row))
            break
        default:
            break
        }
        cell.selectionStyle = .blue
        return cell
    }
    
}

extension RequestSourcesSelectionVC { // MARK: Actions
    
    func backButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func selectButtonPressed() {
        guard let selectedPaths = tableView.indexPathsForSelectedRows else {
            return
        }
        guard let indexPath1: IndexPath? = {
            if selectedPaths.count > 0 {
                return selectedPaths[0]
            }
            return nil
            }() else {
            return
        }
        let indexPath2: IndexPath? = {
            if selectedPaths.count > 1 {
                return selectedPaths[1]
            }
            return nil
        }()

        viewModel.selectSources(source1Path: indexPath1!, source2Path: indexPath2)
        _ = navigationController?.popViewController(animated: true)
    }
    
}
