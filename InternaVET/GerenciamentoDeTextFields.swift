//
//  GerenciamentoDeTextFields.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 31/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class GerenciamentoDeTextFields: NSObject, UITextFieldDelegate {
    var limiteDeCaracteres: Int = Int.max
    weak var delegate: UITextFieldDelegate!
    weak var textField: UITextField!
    
    init(delegate: UITextFieldDelegate, textField: UITextField){
        self.delegate = delegate
        self.textField = textField
        super.init()
        self.textField.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let delegateShouldChange = self.delegate.textField?(textField, shouldChangeCharactersIn: range, replacementString: string)
        let nsText = NSString(string:textField.text!)
        let newTextValue = nsText.replacingCharacters(in: range, with: string)
        return !(newTextValue.lengthOfBytes(using: .utf8) > limiteDeCaracteres) && (delegateShouldChange ?? true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


class TextFieldDelegateApenasNumeros : GerenciamentoDeTextFields{
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let shouldChange = super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)        
        return shouldChange && string.isANumber()
    }
    
}
