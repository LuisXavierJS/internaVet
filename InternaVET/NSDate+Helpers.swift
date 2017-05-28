//
//  NSDate+Helpers.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension NSDate {
    func hourString()->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm"
        return dateFormat.string(from: self as Date)
    }
    
    func toString(withFormat: String = "dd/MM/yyyy hh:mm")->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = withFormat
        return dateFormat.string(from: self as Date)
    }
}
