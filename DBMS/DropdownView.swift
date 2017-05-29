//
//  DropdownView.swift
//  DBMS
//
//  Created by Dmitrii Titov on 23.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift
import pop

enum DropdownViewState {
    case Unselected
    case PreSelected
    case Selected
    case PreUnselected
}

class DropdownView: UIView {
    
    let disposeBag = DisposeBag()
    
    let state = Variable<DropdownViewState>(DropdownViewState.Unselected)
    let title = Variable<String>("")
    let selectedIndex = Variable<Int>(0)
    let requiredHeight = Variable<CGFloat>(45)
    
    var unselectedHeight = 45.0 as CGFloat
    var selectedHeight = 200.0 as CGFloat
    var preStateHeightDelta = 25.0 as CGFloat
    
    let headerButton = DropdownHeaderButton()
    let tableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        self.setupUI()
        self.initBindings()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.initBindings()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupUI()
        self.initBindings()
    }
    
    func setupUI() {
        self.setupTableView()
        self.setupButtons()
        
        self.configureView()
        self.runUnselectedStateAnimation()
    }
    
    func configureView() {
        layer.cornerRadius = 5
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1.5
        layer.masksToBounds = true
        backgroundColor = UIColor.white
    }
    
    func setupTableView() {
        self.addSubview(tableView)
        
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.separatorColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 10000, bottom: 0, right: 0)
    }
    
    func setupButtons() {
        self.addSubview(headerButton)
        headerButton.backgroundColor = CommonCollorsStorage.cellBackgroundColor()
        headerButton.layer.cornerRadius = 5
        headerButton.layer.borderColor = UIColor.black.cgColor
        headerButton.layer.borderWidth = 1.5
        
        headerButton.addTarget(self, action: #selector(self.touchStart), for: .touchDown)
        headerButton.addTarget(self, action: #selector(self.touchFinish), for: .touchUpInside)
        headerButton.addTarget(self, action: #selector(self.touchCanceled), for: .touchCancel)
        headerButton.addTarget(self, action: #selector(self.touchCanceled), for: .touchDragExit)
        headerButton.addTarget(self, action: #selector(self.touchCanceled), for: .touchDragOutside)
    }
    
    func initBindings() {
        
        _ = state.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (state) in
                
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.6,
                               initialSpringVelocity: 0.2,
                               options: [],
                               animations: {
                                self.layoutSubviews()
                },
                               completion: nil)
            })
            .disposed(by: disposeBag)
        
        _ = state.asObservable()
            .map({ (state) -> CGFloat in
                switch state {
                case .Unselected:
                    return self.unselectedHeight
                case .PreSelected:
                    return self.unselectedHeight + self.preStateHeightDelta
                case .Selected:
                    return self.selectedHeight
                case .PreUnselected:
                    return self.selectedHeight - self.preStateHeightDelta
                }
            })
            .bindTo(self.requiredHeight)
            .disposed(by: disposeBag)
        
        _ = title.asObservable()
            .bindTo(headerButton.title)
            .disposed(by: disposeBag)
        
    }
    
}

extension DropdownView: UITableViewDelegate { // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedIndex.value = indexPath.row
        state.value = .Unselected
    }
    
}

extension DropdownView { // MARK: Actions
    
    @objc func touchStart() {
        if state.value == .Selected {
            state.value = .PreUnselected
        }else if state.value == .Unselected {
            state.value = .PreSelected
        }
    }
    
    @objc func touchFinish() {
        if state.value == .PreUnselected {
            state.value = .Unselected
        }else if state.value == .PreSelected {
            state.value = .Selected
        }
    }
    
    @objc func touchCanceled() {
        if state.value == .PreUnselected {
            state.value = .Selected
        }else if state.value == .PreSelected {
            state.value = .Unselected
        }
    }
    
}

extension DropdownView { // MARK: Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        headerButton.frame = CGRect(x: 0, y: 0,
                                    width: self.frame.size.width,
                                    height: unselectedHeight)
        let height = { () -> CGFloat in
            switch state.value {
            case .Unselected:
                return 0
            case .PreSelected:
                return self.unselectedHeight + self.preStateHeightDelta - self.unselectedHeight
            case .Selected:
                return self.selectedHeight - self.unselectedHeight
            case .PreUnselected:
                return self.selectedHeight - self.preStateHeightDelta - self.unselectedHeight
            }
        }()
        tableView.frame = CGRect(x: 0, y: self.unselectedHeight,
                                 width: self.frame.size.width, height: height)
    }
    
}

extension DropdownView { // MARK: Animations
    
    private func animationDuration() -> CGFloat {
        return 0.3
    }
    
    func runUnselectedStateAnimation() {
        let sizeAnimation = POPBasicAnimation(propertyNamed: kPOPViewFrame)
        sizeAnimation?.duration = CFTimeInterval(self.animationDuration())
        sizeAnimation?.toValue = NSValue(cgRect: CGRect(x: 0, y: self.unselectedHeight,
                                                        width: self.frame.size.width, height: 0))
        tableView.pop_add(sizeAnimation, forKey: "UnselectedStateTVAnimation")
    }
    
    func runPreSelectedStateAnimation() {
        let sizeAnimation = POPBasicAnimation(propertyNamed: kPOPViewFrame)
        sizeAnimation?.duration = CFTimeInterval(self.animationDuration())
        sizeAnimation?.toValue = NSValue(cgRect: CGRect(x: 0, y: self.unselectedHeight,
                                                        width: self.frame.size.width, height: self.unselectedHeight + self.preStateHeightDelta))
        tableView.pop_add(sizeAnimation, forKey: "PreSelectedStateTVAnimation")
    }
    
    func runSelectedStateAnimation() {
        let sizeAnimation = POPBasicAnimation(propertyNamed: kPOPViewFrame)
        sizeAnimation?.duration = CFTimeInterval(self.animationDuration())
        sizeAnimation?.toValue = NSValue(cgRect: CGRect(x: 0, y: self.unselectedHeight,
                                                        width: self.frame.size.width, height: self.selectedHeight))
        tableView.pop_add(sizeAnimation, forKey: "SelectedStateTVAnimation")
    }
    
    func runPreUnselectedStateAnimation() {
        let sizeAnimation = POPBasicAnimation(propertyNamed: kPOPViewFrame)
        sizeAnimation?.duration = CFTimeInterval(self.animationDuration())
        sizeAnimation?.toValue = NSValue(cgRect: CGRect(x: 0, y: self.unselectedHeight,
                                                        width: self.frame.size.width, height: self.selectedHeight - self.preStateHeightDelta))
        tableView.pop_add(sizeAnimation, forKey: "PreUnselectedStateTVAnimation")
    }
    
}
