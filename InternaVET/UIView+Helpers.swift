//
//  UIView+Helpers.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 27/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension UIView {
    func layout(animated:Bool,duration:TimeInterval = 0.2){        
        self.setNeedsLayout()
        if !animated {
            self.layoutIfNeeded()
        }else{
            UIView.animate(withDuration: duration) {
                self.layoutIfNeeded()
            }
        }
    }
}
