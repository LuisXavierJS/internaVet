//
//  ViewController+Helpers.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 26/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

public extension UIViewController {    
    public class func instantiate<T : UIViewController>(_ identifier: String? = nil, forStoryboard: String = "Main") -> T? {
        let storyboard = UIStoryboard(name: forStoryboard, bundle: nil)
        guard let ident = identifier else {
            let className = self.className()
            return storyboard.instantiateViewController(withIdentifier: className) as? T
        }
        return storyboard.instantiateViewController(withIdentifier: ident) as? T
    }
    
    public class func instantiate(withIdentifier identifier: String, forStoryboard: String = "Main") -> Self? {
        return self.instantiate(identifier,forStoryboard: forStoryboard)
    }
    
    public class func instantiate(forStoryboard: String = "Main") -> Self? {
        return self.instantiate(nil,forStoryboard: forStoryboard)
    }
    
    public class func instantiateThisNavigationController(forStoryboard: String = "Main") -> UINavigationController?{
        let className = self.className().replacingOccurrences(of: "VC", with: "")
        let navigationName = className+"NavigationVC"
        let storyboard = UIStoryboard(name: forStoryboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: navigationName) as? UINavigationController
    }
    
    func presentAlert(title: String?, message: String?, actions: [UIAlertAction] = [UIAlertAction(title: "Ok", style: .default, handler: nil)]){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for act in actions{alert.addAction(act)}
        self.present(alert, animated: true, completion: nil)
    }
}


typealias InputFinish = ((String)->Void)

class InputResponder: UITextField{
    private var resignResponderEvents:[InputFinish] = []
    
    fileprivate func addCurrentResignEvent(event:@escaping InputFinish){
        resignResponderEvents.append(event)
    }
    
    fileprivate func removeCurrentResignEvent(){
        if resignResponderEvents.count > 0 {
            _=resignResponderEvents.remove(at: resignResponderEvents.count - 1)
        }
    }
    
    fileprivate func currentResignEvent()->InputFinish?{
        return resignResponderEvents.last
    }
}

protocol PickerInputViewProtocol{
    var inputPickerResponder: UITextField{get}
}

extension UIViewController: PickerInputViewProtocol{
    
    fileprivate static let responder = InputResponder()
    
    var inputPickerResponder: UITextField {
        return UIViewController.responder
    }
    
    func showBottomInputPickerView(inputViewId: String, inputView:UIView, finishEvent: @escaping InputFinish){
        self.view.addSubview(self.inputPickerResponder)
        inputView.backgroundColor = UIColor.white
        let doneButton = UIBarButtonItem(title: "Feito", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.closeToolbar))
        let toolBar:UIToolbar = UIToolbar()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.barTintColor = .white
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true
        self.inputPickerResponder.text = inputViewId
        self.inputPickerResponder.inputView = inputView
        self.inputPickerResponder.inputAccessoryView = toolBar
        self.inputPickerResponder.becomeFirstResponder()
        if let responder = self.inputPickerResponder as? InputResponder{
            responder.addCurrentResignEvent(event: finishEvent)
        }
    }
    
    @objc fileprivate func closeToolbar(){
        self.inputPickerResponder.resignFirstResponder()
        self.inputPickerResponder.removeFromSuperview()
        if let responder = self.inputPickerResponder as? InputResponder,
            let inputId = responder.text,
            let currentEvent = responder.currentResignEvent(){
            responder.removeCurrentResignEvent()
            currentEvent(inputId)
        }
    }
    
    
    
}

