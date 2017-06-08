//
//  DataBaseRouter.swift
//  DBMS
//
//  Created by Dmitrii Titov on 13.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import DTAlertViewContainer

private let sharedInstance = DataBaseRouter()

class DataBaseRouter: NSObject {
    
    var mainNavigationController : UINavigationController!
    var selectionDataBaseNavigationController : UINavigationController!
    
    class var shared : DataBaseRouter {
        return sharedInstance
    }
    
    func showDataBaseScreen() {
        
    }
    
    func moveToDataBaseScenario(dbFramework: DataBaseFramework) {
        mainNavigationController = UINavigationController(rootViewController: StoryboardHelper.dataBaseVC(dbFramework: dbFramework))
        mainNavigationController.isNavigationBarHidden = true
        UIView.transition(with: ((UIApplication.shared.delegate?.window)!)!,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            ((UIApplication.shared.delegate?.window)!)?.rootViewController = self.mainNavigationController
        }) { (completed) in
            
        }
    }
    
    func moveToSelectionDataBaseScenario() {
        mainNavigationController = UINavigationController(rootViewController: StoryboardHelper.selectDBVC())
        mainNavigationController.isNavigationBarHidden = true
        UIView.transition(with: ((UIApplication.shared.delegate?.window)!)!,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            ((UIApplication.shared.delegate?.window)!)?.rootViewController = self.mainNavigationController
        }) { (completed) in
            
        }
    }
    
    // MARK: Requests
    
    func showRequestsListScreen(dbFramework: DataBaseFramework) {
        let vc = StoryboardHelper.requestsListVC(dbFramework: dbFramework)
        mainNavigationController.pushViewController(vc, animated: true)
    }
    
    func showRequestVC(dbFramework: DataBaseFramework, requestName: String) {
        let vc = StoryboardHelper.requestVC(dbFramework: dbFramework, requestName: requestName)
        mainNavigationController.pushViewController(vc, animated: true)
    }
    
    func showRequestSourcesSelectionScreen(dbFramework: DataBaseFramework, requestSource: RequestSource,
                                           requestsNamesToSkip: [String], selectionAction: @escaping ((RequestSource) -> ())) {
        let vc = StoryboardHelper.requestSourcesSelectionVC(dbFramework: dbFramework, requestSource: requestSource,
                                                            requestsNamesToSkip: requestsNamesToSkip, selectionAction: selectionAction)
        mainNavigationController.pushViewController(vc, animated: true)
    }
    
    func showRequestSelectAttributesScreen(dbFramework: DataBaseFramework, selectedItems: [RequestSelectionItem],
                                           availableItems: [RequestSelectionItem],
                                           selectionAction: @escaping (([RequestSelectionItem]) -> ())) {
        let vc = StoryboardHelper.requestSelectAttributesVC(dbFramework: dbFramework, selectedItems: selectedItems,
                                                            availableItems: availableItems, selectionAction: selectionAction)
        mainNavigationController.pushViewController(vc, animated: true)
    }
    
    func showRequestEditConditionScreen(dbFramework: DataBaseFramework, conditionItem: RequestConditionItem, availableSelectionItems: [RequestSelectionItem]) {
        guard let topVC = mainNavigationController.topViewController else { return }
        let vc = DTAlertViewContainerController()
        vc.appearenceDuration = 0.3
        vc.scrollView.isScrollEnabled = false
        vc.alertViewContainsTableView = true
        let viewModel = RequestEditConditionItemVM(dbFramework: dbFramework, conditionItem: conditionItem, availableSelectionItems: availableSelectionItems)
        let alertView = RequestEditConditionItemView(viewModel: viewModel)
        vc.presentOverVC(topVC, alert: alertView, appearenceAnimation: .fade, completion: nil)
    }
    
    func showRequestExecutionResultScreen(dbFramework: DataBaseFramework, requestName: String) {
        let vc = StoryboardHelper.requestExecutionResultVC(dbFramework: dbFramework, requestName: requestName)
        mainNavigationController.pushViewController(vc, animated: true)
    }
    
    // MARK: Filling
    
    func showFillingTablesListScreen(dbFramework: DataBaseFramework) {
        let vc = StoryboardHelper.fillTablesListVC(dbFramework: dbFramework)
        mainNavigationController.pushViewController(vc, animated: true)
    }
    
    func showFillTableScreen(dbFramework: DataBaseFramework, tableName: String) {
        let vc = StoryboardHelper.fillTableVC(dbFramework: dbFramework, tableName: tableName)
        mainNavigationController.pushViewController(vc, animated: true)
    }
    
    func showRecordScreen(dbFramework: DataBaseFramework, tableName: String, record: Record?, saveAction: (() -> ())?) {
        guard let topVC = mainNavigationController.topViewController else { return }
        let vm = RecordScreenVM(dbFramework: dbFramework, tableName: tableName, record: record)
        let alertView = RecordView(viewModel: vm)
        let vc = DTAlertViewContainerController()
        vc.positionBinding = .centre
        vc.dismissAction = saveAction
        vc.presentOverVC(topVC, alert: alertView, appearenceAnimation: .fromBottom, completion: nil)
    }
    
    
    // MARK: Editing
    
    func showEditTablesListScreen(dbFramework: DataBaseFramework) {
        let vc = StoryboardHelper.editTablesListVC(dbFramework: dbFramework)
        mainNavigationController.pushViewController(vc, animated: true)
    }
    
    func showEditTableScreen(dbFramework: DataBaseFramework, tableName: String) {
        let vc = StoryboardHelper.editTableVC(dbFramework: dbFramework, tableName: tableName)
        mainNavigationController.pushViewController(vc, animated: true)
    }
    
    func showColumnScreen(dbFramework: DataBaseFramework, tableName: String, columnName: String) {
        let vc = StoryboardHelper.columnVC(dbFramework: dbFramework, tableName: tableName, columnName: columnName)
        mainNavigationController.pushViewController(vc, animated: true)
    }
    
    func showEditRelationshipScreen(dbFramework: DataBaseFramework, relationship: TablesRelationship?) {
        guard let topVC = mainNavigationController.topViewController else { return }
        let viewModel = RelationshipViewVM(dbFramework: dbFramework, relationship: relationship)
        let vc = DTAlertViewContainerController()
        let av = RelationshipView(viewModel: viewModel)
        vc.presentOverVC(topVC, alert: av, appearenceAnimation: .fromBottom, completion: nil)
    }
}




/*     Pattern
 
 func show<#SMTH#>Screen() {
 let vc = StoryboardHelper.<#Screen#>()
 mainNavigationController.pushViewController(vc, animated: true)
 }
 
 */
