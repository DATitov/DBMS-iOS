//
//  StoryboardHelper.swift
//  DBMS
//
//  Created by Dmitrii Titov on 20.03.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

struct Storyboard {
    static let editTables = UIStoryboard(name: "EditTables", bundle: nil)
    static let fillTables = UIStoryboard(name: "TablesFilling", bundle: nil)
    static let request = UIStoryboard(name: "RequestStoryboard", bundle: nil)
    static let helpers = UIStoryboard(name: "Helpers", bundle: nil)
    static let main = UIStoryboard(name: "Main", bundle: nil)
}

class StoryboardHelper: NSObject {
    
    // MARK: Main
    
    class func selectDBVC() -> SelectDBMSCVController {
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "SelectDBMSCVController") as! SelectDBMSCVController
        return vc
    }
    
    class func dataBaseVC(dbFramework: DataBaseFramework) -> DataBaseVController {
        let vc = Storyboard.main.instantiateViewController(withIdentifier: "DataBaseVController") as! DataBaseVController
        let viewModel = DataBaseVM(dbFramework: dbFramework)
        vc.viewModel = viewModel
        return vc
    }
    
    // MARK: Filling
    
    class func fillTablesListVC(dbFramework: DataBaseFramework) -> FillTablesListVC {
        let vc = Storyboard.fillTables.instantiateViewController(withIdentifier: "FillTablesListVC") as! FillTablesListVC
        let viewModel = FillTablesListVM(dbFramework: dbFramework)
        vc.viewModel = viewModel
        return vc
    }
    
    class func fillTableVC(dbFramework: DataBaseFramework, tableName: String) -> FillTableVC {
        let vc = Storyboard.fillTables.instantiateViewController(withIdentifier: "FillTableVC") as! FillTableVC
        let viewModel = FillTableVM(dbFramework: dbFramework, tableName: tableName)
        vc.viewModel = viewModel
        return vc
    }
    
    //  MARK: Requests
    
    class func requestsListVC(dbFramework: DataBaseFramework) -> RequestsListVC {
        let vc = Storyboard.request.instantiateViewController(withIdentifier: "RequestsListVC") as! RequestsListVC
        let viewModel = RequestsListVM(dbFramework: dbFramework)
        vc.viewModel = viewModel
        return vc
    }
    
    class func requestVC(dbFramework: DataBaseFramework, requestName: String) -> RequestVC {
        let vc = Storyboard.request.instantiateViewController(withIdentifier: "RequestVC") as! RequestVC
        let viewModel = RequestVM(dbFramework: dbFramework, requestName: requestName)
        vc.viewModel = viewModel
        return vc
    }
    
    class func requestSourcesSelectionVC(dbFramework: DataBaseFramework, requestSource: RequestSource, requestsNamesToSkip: [String], selectionAction: @escaping ((RequestSource) -> ())) -> RequestSourcesSelectionVC {
        let vc = Storyboard.request.instantiateViewController(withIdentifier: "RequestSourcesSelectionVC") as! RequestSourcesSelectionVC
        let viewModel = RequestSourcesSelectionVM(dbFramework: dbFramework, requestSource: requestSource, requestsNamesToSkip: requestsNamesToSkip, selectionAction: selectionAction)
        vc.viewModel = viewModel
        return vc
    }
    
    class func requestSelectAttributesVC(dbFramework: DataBaseFramework, selectedItems: [RequestSelectionItem], availableItems: [RequestSelectionItem],
                          selectionAction: @escaping (([RequestSelectionItem]) -> ())) -> RequestSelectAttributesVC {
        let vc = Storyboard.request.instantiateViewController(withIdentifier: "RequestSelectAttributesVC") as! RequestSelectAttributesVC
        let viewModel = RequestSelectAttributesVM(dbFramework: dbFramework, selectedItems: selectedItems,
                                                           availableItems: availableItems, selectionAction: selectionAction)
        vc.viewModel = viewModel
        return vc
    }
    
    class func requestExecutionResultVC(dbFramework: DataBaseFramework, requestName: String) -> RequestExecutionResultVC {
        let vc = Storyboard.request.instantiateViewController(withIdentifier: "RequestExecutionResultVC") as! RequestExecutionResultVC
        let viewModel = RequestExecutionResultVM(dbFramework: dbFramework, requestName: requestName)
        vc.viewModel = viewModel
        return vc
    }
    
    //  MARK: Edit Tables
    
    class func editTablesListVC(dbFramework: DataBaseFramework) -> EditTablesListVC {
        let vc = Storyboard.editTables.instantiateViewController(withIdentifier: "EditTablesListVC") as! EditTablesListVC
        let viewModel = EditTablesListVM(dbFramework: dbFramework)
        vc.viewModel = viewModel
        return vc
    }
    
    class func editTableVC(dbFramework: DataBaseFramework, tableName: String) -> EditTableVC {
        let vc = Storyboard.editTables.instantiateViewController(withIdentifier: "EditTableVC") as! EditTableVC
        let viewModel = EditTableVM(dbFramework: dbFramework, tableName: tableName)
        vc.viewModel = viewModel
        return vc
    }

    class func columnVC(dbFramework: DataBaseFramework, tableName: String, columnName: String) -> EditColumnVController {
        let vc = Storyboard.editTables.instantiateViewController(withIdentifier: "EditColumnVController") as! EditColumnVController
        let viewModel = EditColumnVM(dbFramework: dbFramework, tableName: tableName, columnName: columnName)
        vc.viewModel = viewModel
        return vc
    }
    
    // MARK: Other
    
    class func pdfWebView(data: Data, path: URL) -> PdfWebView {
        let vc = Storyboard.helpers.instantiateViewController(withIdentifier: "PdfWebView") as! PdfWebView
        vc.data = data
        vc.path = path
        return vc
    }
    
}

/*
 class func <#Some#>VC(dbFramework: DataBaseFramework,<#Some#>) -> <#Some#> {
 let vc = Storyboard.<#Some#>.instantiateViewController(withIdentifier: "<#Some#>") as! <#Some#>
 let viewModel = <#Some#>(<#Some#>)
 //vc.viewModel = viewModel
 return vc
 }
 */
