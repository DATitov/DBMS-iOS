//
//  RecordVC.swift
//  DBMS
//
//  Created by Dmitrii Titov on 13.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RecordVC: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var viewModel: RecordScreenVM!
    
    var cancelButtonPressedAction: (() -> ())?
    var saveButtonPressedAction: (() -> ())?
    
    @IBOutlet weak var backgroundButton: AlertViewBackgroundButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var recordView: RecordView! {
        didSet {
            self.recordView.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update(withTableData: viewModel.tableData, andRecord: viewModel.record)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let leadingOffset = 10.0 as CGFloat
        backgroundButton.frame = view.bounds
        scrollView.frame = view.bounds
        recordView.frame = CGRect(x: leadingOffset, y: recordView.frame.origin.y,
                                  width: view.frame.size.width - leadingOffset * 2, height: recordView.requiredHeight())
    }
    
    func update(withTableData tabeData: TableData, andRecord record: Record?) {
        recordView.update(withTableData: tabeData, andRecord: record)
    }
    
    func setupUI() {
        
    }
    
    func bindRecord() {
        
    }
    
}

extension RecordVC: AlertViewDelegate {
    
    func cancelButtonPressed() {
        guard cancelButtonPressedAction != nil else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.cancelButtonPressedAction!()
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveButtonPressed(object: AnyObject) {
        guard object.isMember(of: Record.self) else {
            return
        }
        var error: Error?
        DataManagerAPI.shared.addRecord(dbFramework: viewModel.dbFramework, tableName: viewModel.tableData.name, record: object as! Record, error: &error)
        if error != nil {
            print(error ?? "")
        }
        guard saveButtonPressedAction != nil else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        self.saveButtonPressedAction!()
        self.dismiss(animated: true, completion: nil)
    }
    
}
