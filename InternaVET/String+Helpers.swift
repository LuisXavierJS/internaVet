//
//  String+Helpers.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 29/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension String {
    func attributed(withSize size: CGFloat = 15) -> NSAttributedString{
        let attributes: [String:Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: size)]
        return NSAttributedString(string: self, attributes: attributes)
    }
    
    func isANumber()->Bool{
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: self)
        return allowedCharacters.isSuperset(of: characterSet)
    }
}
