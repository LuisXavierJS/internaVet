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
    
    func selectTitle(title: String){
        for segment in 0..<self.numberOfSegments{
            if self.titleForSegment(at: segment) == title{
                self.selectedSegmentIndex = segment
                return
            }
        }
    }
}
