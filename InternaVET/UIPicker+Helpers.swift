//
//  UIPicker+Helpers.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 31/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension UIPickerView {

    func selectedTitle(inComponent component: Int)->String?{
        if let label = self.view(forRow: self.selectedRow(inComponent: component), forComponent: component) as? UILabel{
            return label.text
        }else if let delegate = self.delegate{
            return delegate.pickerView?(self, titleForRow: self.selectedRow(inComponent: component), forComponent: component)
        }
        return nil
    }

    func selectTitle(title: String, inComponent component: Int){
        if let datasource = self.dataSource as? GerenciadorDePickerView{
            datasource.selectTitle(title: title, inComponent: component)
        }
    }
    
}
