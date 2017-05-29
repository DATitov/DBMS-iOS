//
//  SelectDBMSCVController.swift
//  DBMS
//
//  Created by Dmitrii Titov on 01.04.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class SelectDBMSCVController: BaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        collectionView?.register(UINib(nibName: "DBMSCViewCell", bundle: nil), forCellWithReuseIdentifier: "DBMSCViewCell")
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView?.register(SelectDBMSCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SelectDBMSCollectionReusableView")
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
}

extension SelectDBMSCVController { // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataBasesManager.shared.dataBasesTypesAvailable().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DBMSCViewCell", for: indexPath) as! DBMSCViewCell
        
        cell.label.text = self.DataBaseFramework(for: indexPath.row).rawValue
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SelectDBMSCollectionReusableView", for: indexPath) as! SelectDBMSCollectionReusableView
            headerView.label1.text = NSLocalizedString("choose_framework", comment: "")
            headerView.label2.text = NSLocalizedString("data_bases_management_system", comment: "")
            return headerView
        default:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SelectDBMSCollectionReusableView", for: indexPath)
        }
    }
    
    func DataBaseFramework(for index: Int) -> DataBaseFramework {
        var type : DataBaseFramework = .None
        switch index {
        case 0:
            type = .SQLite
            break
        case 1:
            type = .FMDB
            break
        case 2:
            type = .CoreData
            break
        case 3:
            type = .FileSystem
            break
        default:
            break
        }
        return type
    }
    
}

extension SelectDBMSCVController  { // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        collectionView.deselectItem(at: indexPath, animated: true)
        
        
        DataBaseRouter.shared.moveToDataBaseScenario(dbFramework: self.DataBaseFramework(for: indexPath.row))
    }
    
}

extension SelectDBMSCVController: UICollectionViewDelegateFlowLayout { // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        
        let size = CGSize(width: calculateItemWidth(), height: calculateItemHeight())
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 100)
    }
 
    //  MARK: Calculations
    
    private func calculateItemHeight() -> CGFloat {
        let numberOfLines = (collectionView?.dataSource?.collectionView(collectionView!, numberOfItemsInSection: 0))! / 2
        let h1 = self.collectionView(collectionView!, layout: collectionViewLayout, minimumLineSpacingForSectionAt: 0) * CGFloat(numberOfLines)
        let h2 = (self.collectionView(collectionView!, layout: collectionViewLayout, insetForSectionAt: 0).top +
            self.collectionView(collectionView!, layout: collectionViewLayout, insetForSectionAt: 0).bottom) * CGFloat(numberOfLines)
        let h3 = self.collectionView(collectionView!, layout: collectionViewLayout, referenceSizeForHeaderInSection: 0).height
        let h4 = collectionView(collectionView!, layout: collectionViewLayout, referenceSizeForHeaderInSection: 0)   .height
        let height = ((self.collectionView?.frame.size.height)! - h1 - h2 - h3 - h4) / CGFloat(2 /*numberOfLines / 2 + 1*/)
        return height
    }
    
    private func calculateItemWidth() -> CGFloat {
        let w1 = (self.collectionView(collectionView!, layout: collectionViewLayout, insetForSectionAt: 0).left +
            self.collectionView(collectionView!, layout: collectionViewLayout, insetForSectionAt: 0).left ) * (7 / 4)
        let width = CGFloat((self.collectionView?.frame.size.width)! - w1) / 2
        return width
    }
    
}
