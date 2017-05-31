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
