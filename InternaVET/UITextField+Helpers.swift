//
//  UITextField+Helpers.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 05/06/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension UITextField {
    func configureDarkGreenBorder(){
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.mediumGreen.cgColor
        self.layer.borderWidth = 1
    }
}
