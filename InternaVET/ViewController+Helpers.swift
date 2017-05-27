//
//  ViewController+Helpers.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 26/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

public extension UIViewController {
    public class func getStoryboard() -> UIStoryboard {
        let moduleClassName = NSStringFromClass(self.classForCoder())
        let className = moduleClassName.components(separatedBy: ".").last!
        let storyboardName = className.replacingOccurrences(of: "ViewController", with: "")
        return UIStoryboard(name: storyboardName, bundle: Bundle.main)
    }
    
    public class func instantiate<T : UIViewController>(_ identifier: String? = nil) -> T? {
        guard let ident = identifier else {
            return self.getStoryboard().instantiateInitialViewController() as? T
        }
        return self.getStoryboard().instantiateViewController(withIdentifier: ident) as? T
    }
    
    public class func instantiate(withIdentifier identifier: String) -> Self? {
        return self.instantiate(identifier)
    }
    
    public class func instantiate() -> Self? {
        return self.instantiate(nil)
    }
}
