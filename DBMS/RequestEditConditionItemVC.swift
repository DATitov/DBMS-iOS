
//
//  RequestEditConditionItemVC.swift
//  DBMS
//
//  Created by Dmitrii Titov on 23.05.17.
//  Copyright © 2017 Dmitrii Titov. All rights reserved.
//

import UIKit
import RxSwift

enum KeyboardState {
    case onScreen
    case offScreen
}

class RequestEditConditionItemVC: BaseViewController {
    
    let dispodeBag = DisposeBag()
    
    @IBOutlet weak var editConditionView: RequestEditConditionItemView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundButton: AlertViewBackgroundButton!
    
    var keyboardHeightInScreen = 0.0 as CGFloat
    let requiredHeight = Variable<CGFloat>(0)
    
    let minimumVerticalOffset = 30.0 as CGFloat
    
    var viewModel: RequestEditConditionItemVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editConditionView.bindViewModel(viewModel: viewModel)
        self.initBindingigs()
        editConditionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.layoutEditConditionView()
    }
    
    func initBindingigs() {
        
        _ = editConditionView.requiredHeight.asObservable()
            .bindTo(self.requiredHeight)
            .disposed(by: dispodeBag)
        
        _ = editConditionView.requiredHeight.asObservable()
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: {  [unowned self] _ in
                
                UIView.animate(withDuration: 0.3,
                               delay: 0,
                               usingSpringWithDamping: 0.6,
                               initialSpringVelocity: 0.2,
                               options: [],
                               animations: {
                                self.layoutEditConditionView()
                },
                               completion: nil)
            })
            .disposed(by: dispodeBag)
        
        _ = NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillChangeFrame).asObservable()
            .map({ (notification) -> (CGRect, Double) in
                let frame = { () -> CGRect in 
                    guard let frame = notification.userInfo?["UIKeyboardFrameEndUserInfoKey"] else {
                        return CGRect.zero
                    }
                    return frame as! CGRect
                }()
                let appearenceDuration = { () -> Double in 
                    guard let appearenceDuration = notification.userInfo?["UIKeyboardAnimationDurationUserInfoKey"] else {
                        return 0.2
                    }
                    return appearenceDuration as! Double
                }()
                return (frame, appearenceDuration)
            })
            .map({ (frame, appearenceDuration) -> (CGFloat, Double) in
                if frame.origin.y > UIScreen.main.bounds.size.height {
                    return (0, appearenceDuration)
                }else{
                    return (min(frame.size.height, UIScreen.main.bounds.size.height - frame.origin.y), appearenceDuration)
                }
            })
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { (keyboardHeightInScreen, appearenceDuration) in
                self.keyboardHeightInScreen = keyboardHeightInScreen
                UIView.animate(withDuration: TimeInterval(appearenceDuration),
                               delay: 0,
                               options: UIViewAnimationOptions.curveEaseOut,
                               animations: {
                                self.layoutEditConditionView()
                },
                               completion: nil)
            })
            .disposed(by: dispodeBag)
        
        
    }
    
    func layoutEditConditionView() {
        
        let height = editConditionView.requiredHeight.value
        
        let contentHeight = { () -> CGFloat in
            if height + minimumVerticalOffset * 2 + keyboardHeightInScreen > UIScreen.main.bounds.size.height {
                return height + minimumVerticalOffset * 2 + keyboardHeightInScreen
            }else{
                return UIScreen.main.bounds.size.height
            }
        }()
        
        let yCoordinate = {() -> CGFloat in
            if height + (scrollView.contentSize.height - height) / 2 > UIScreen.main.bounds.size.height - keyboardHeightInScreen {
                return (contentHeight - keyboardHeightInScreen - height) / 2
            }else{
                return (contentHeight - height) / 2
            }
        }()
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: contentHeight)
        let horisontalOffset = 15.0 as CGFloat
        editConditionView.frame = CGRect(x: horisontalOffset, y: yCoordinate,
                                         width: scrollView.contentSize.width - horisontalOffset * 2, height: height)
        backgroundButton.frame = view.bounds
        scrollView.frame = view.bounds
    }
    
}

extension RequestEditConditionItemVC: AlertViewDelegate {
    
    func cancelButtonPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saveButtonPressed(object: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

/*
 _ = NotificationCenter.default.rx
 .notification(NSNotification.Name.UIKeyboardDidChangeFrame)
 .map { notification -> CGFloat in
 (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.origin.y ?? 0
 }
 .map({ (yCoord) -> CGFloat in
 let delta = UIScreen.main.bounds.size.height - yCoord
 return delta >= 0 ? delta : 0
 })
 .bindTo(self.keyboardHeightInScreen)
 .disposed(by: dispodeBag)
 
 _ = NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillShow).asObservable()
 .subscribeOn(MainScheduler.instance)
 .subscribe(onNext: { (notification) in
 UIView.animate(withDuration: 0.2,
 animations: {
 self.layout(keyboardHidden: false)
 })
 })
 .disposed(by: dispodeBag)
 
 _ = NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillHide).asObservable()
 .subscribeOn(MainScheduler.instance)
 .subscribe(onNext: { (notification) in
 UIView.animate(withDuration: 0.2,
 animations: {
 self.layout(keyboardHidden: true)
 })
 })
 .disposed(by: dispodeBag)
 */
