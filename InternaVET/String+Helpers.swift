//
//  String+Helpers.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 29/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension String {
    var attributed: NSAttributedString{
        return NSAttributedString(string: self)
    }
    
    var nsString: NSString{
        return NSString(string: self)
    }
    
    func isANumber()->Bool{
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: self)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func attributed(withSize size: CGFloat = 15, color: UIColor = UIColor.black) -> NSAttributedString{
        let attributes: [String:Any] = [NSFontAttributeName: UIFont.systemFont(ofSize: size), NSForegroundColorAttributeName: color]
        return NSAttributedString(string: self, attributes: attributes)
    }
    
}


extension NSAttributedString{
    func resized(resizedParts: [String], size: CGFloat) -> NSAttributedString{
        let finalString = NSMutableAttributedString(attributedString: self)
        let boldFontAttribute = [NSFontAttributeName:UIFont.systemFont(ofSize: size)]
        for resizedPart in resizedParts {
            finalString.addAttributes(boldFontAttribute, range: NSString(string:self.string).range(of: resizedPart))
        }
        return finalString
    }
    
    func bold(boldPartsOfString: [String], size: CGFloat) -> NSAttributedString{
        let finalString = NSMutableAttributedString(attributedString: self)
        let boldFontAttribute = [NSFontAttributeName:UIFont.boldSystemFont(ofSize: size)]
        for boldPartOfString in boldPartsOfString {
            finalString.addAttributes(boldFontAttribute, range: NSString(string:self.string).range(of: boldPartOfString))
        }
        return finalString
    }
    
    func colored(coloredParts: [String], color: UIColor) -> NSAttributedString{
        let finalString = NSMutableAttributedString(attributedString: self)
        let boldFontAttribute = [NSForegroundColorAttributeName:color]
        for colorPart in coloredParts {
            finalString.addAttributes(boldFontAttribute, range: NSString(string:self.string).range(of: colorPart))
        }
        return finalString
    }
}
