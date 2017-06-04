
//
//  CGRect.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 18/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension CGRect {
    var bottomYLine:CGFloat{
        return self.origin.y + self.size.height
    }
    
    func withY(y:CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: y, width: size.width, height: size.height)
    }
    func withX(x:CGFloat) -> CGRect {
        return CGRect(x: x, y: origin.y, width: size.width, height: size.height)
    }
    func withWidth(width:CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: width, height: size.height)
    }
    func withHeight(height:CGFloat) -> CGRect {
        return CGRect(x: origin.x, y: origin.y, width: size.width, height: height)
    }
    
    mutating func setY(y:CGFloat) {
        self = CGRect(x: origin.x, y: y, width: size.width, height: size.height)
    }
    mutating func setX(x:CGFloat) {
        self = CGRect(x: x, y: origin.y, width: size.width, height: size.height)
    }
    mutating func setWidth(width:CGFloat) {
        self = CGRect(x: origin.x, y: origin.y, width: width, height: size.height)
    }
    mutating func setHeight(height:CGFloat) {
        self = CGRect(x: origin.x, y: origin.y, width: size.width, height: height)
    }
}
