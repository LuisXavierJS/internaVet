//
//  UISegment+Helpers.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 31/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension UISegmentedControl {
    func selectedTitle()->String?{
        return self.titleForSegment(at: self.selectedSegmentIndex)
    }
}
