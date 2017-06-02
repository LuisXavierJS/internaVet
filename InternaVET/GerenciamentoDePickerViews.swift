//
//  GerenciamentoDePickerViews.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 29/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class GerenciadorDePickerView: NSObject, UIPickerViewDataSource, UIPickerViewDelegate{
    weak var delegate: UIPickerViewDelegate!
    weak var pickerView: UIPickerView!
    var dataSource: [String] {
        return []
    }
    
    init(delegate: UIPickerViewDelegate, pickerView: UIPickerView){
        self.delegate = delegate
        self.pickerView = pickerView
        super.init()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        if let label = view as? UILabel {
            label.attributedText = dataSource[row].attributed(withSize: 15)
            return label
        }else{
            let pickerLabel = UILabel()
            pickerLabel.attributedText = dataSource[row].attributed(withSize: 15)
            pickerLabel.textAlignment = NSTextAlignment.center
            return pickerLabel
        }
    }
    
    func selectTitle(title: String, inComponent component: Int){
        if let index = self.dataSource.index(of: title){
            self.pickerView.selectRow(index, inComponent: component, animated: false)
        }
    }
}

class PickerViewDataSourceDeEspecies: GerenciadorDePickerView{
    let especies:[String] = ["Felis Catus", "Canis Familiaris", "Outra Espécie"]
    
    override var dataSource: [String] {
        return especies
    }
}

class PickerViewDataSourceDeIdade: GerenciadorDePickerView{
    let idades:[String] = ["1 mês","2 meses","3 meses","4 meses","5 meses","6 meses","7 meses","8 meses","9 meses","10 meses","11 meses","1 ano","2 anos","3 anos","4 anos","5 anos","6 anos","7 anos","8 anos","9 anos","10 anos","11 anos","12 anos","13 anos","14 anos","15 anos","16 anos","17 anos","18 anos","19 anos","20 anos"]
    
    override var dataSource: [String] {
        return idades
    }
}

class PickerViewDataSourceDeCanil: GerenciadorDePickerView{
    fileprivate lazy var canisLivres: [String] = {
        var source: [String] = ["--"]
        source.append(contentsOf: CanilDAO.canisLivres())
        return source
    }()
    
    override var dataSource: [String] {
        return canisLivres
    }
    
    func insertCanil(numeroCanil: Int){
        var index: Int = 0
        for canil in canisLivres {
            if let nCanil = Int(canil),
                nCanil >= numeroCanil{
                break
            }
            index+=1
        }
         self.canisLivres.insert(String(numeroCanil), at: index)
    }
}

