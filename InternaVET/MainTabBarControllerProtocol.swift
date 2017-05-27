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

extension MainTabBarControllerItemProtocol where Self:UIViewController, Self:CadastroControllerDelegate {
    func presentCadastroControllerOfType<T: UIViewController>(type: T.Type){
        let navigationController = type.instantiateThisNavigationController(forStoryboard: "Cadastros")!
        if let cadastroController = navigationController.topViewController as? CadastroViewControllerProtocol{
            cadastroController.delegate = self
        }
        self.navigationController?.present(navigationController, animated: true, completion: nil)
    }
    
}
