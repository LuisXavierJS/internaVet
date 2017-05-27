//
//  MainTabBarControllerProtocol.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 25/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@objc protocol MainTabBarControllerItemProtocol: class {
    func addButtonTapped()
}


@objc protocol CadastroControllerDelegate {
    
}

extension MainTabBarControllerItemProtocol where Self:UIViewController, Self:CadastroControllerDelegate {
    func presentCadastroControllerOfType<T: UIViewController>(type: T.Type){
        let nav = type.instantiateThisNavigationController(forStoryboard: "Cadastros")!
        if let vc = nav.topViewController as? T{
            
        }
        self.navigationController?.present(nav, animated: true, completion: nil)
    }
    
}
