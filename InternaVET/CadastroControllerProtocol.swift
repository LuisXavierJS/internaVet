//
//  CadastroControllerProtocol.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 27/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit
import CoreData

@objc protocol CadastroControllerDelegate : class {
}

@objc protocol CadastroViewControllerProtocol {
    weak var delegate: CadastroControllerDelegate? {get set}
}
