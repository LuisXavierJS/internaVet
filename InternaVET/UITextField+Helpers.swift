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

extension UILabel {
    
    func isTruncated() -> Bool {
        
        if let string = self.text {
            let size: CGSize = (string as NSString).boundingRect(
                with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude),
                options: NSStringDrawingOptions.usesLineFragmentOrigin,
                attributes: [NSFontAttributeName: self.font],
                context: nil).size
            
            return (size.height > self.bounds.size.height)
        }
        
        return false
    }
    
}
