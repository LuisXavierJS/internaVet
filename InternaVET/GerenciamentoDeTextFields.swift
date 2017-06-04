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

class TextFieldDelegateAutoComplete: GerenciamentoDeTextFields, UITableViewDataSource, UITableViewDelegate{
    private var autoCompleteDataSource: AutoCompleteDataSource? = nil
    private var tableDataSource: [String]? = nil
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.layer.cornerRadius = 5
        table.layer.borderColor = UIColor.gray.cgColor
        table.layer.borderWidth = 1
        table.isHidden = true
        table.alpha = 0
        let localTableFrame = self.textField.frame.withY(y: self.textField.frame.bottomYLine).withHeight(height: 0)
        let newFrame = self.textField.superview?.superview?.convert(localTableFrame, from: self.textField.superview)
        table.frame = newFrame!
        self.textField.superview?.clipsToBounds = false
        self.textField.superview?.superview?.addSubview(table)
        self.textField.superview?.superview?.bringSubview(toFront: table)
        return table
    }()
    
    init(tipoComplete: TipoDeCompletador, delegate: UITextFieldDelegate, textField: UITextField){
        self.autoCompleteDataSource = AutoCompleteDataSource(tipoDeAutoComplete: tipoComplete)
        super.init(delegate: delegate, textField: textField)
    }
    
    func setTipoComplete(novoTipo: TipoDeCompletador){
        if self.autoCompleteDataSource?.tipoDeCompletador == novoTipo { return }
        self.autoCompleteDataSource?.tipoDeCompletador = novoTipo
        self.tableDataSource = nil
        self.reloadTable()
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let string = textField.text!.nsString.replacingCharacters(in: range, with: string)
        self.tableDataSource = self.autoCompleteDataSource?.stringsQueCompletam(string: string)
        self.reloadTable()
        return super.textField(textField, shouldChangeCharactersIn: range, replacementString: string)
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.tableDataSource = nil
        self.reloadTable()
        return super.textFieldShouldReturn(textField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tableDataSource = nil
        self.reloadTable()
        self.delegate.textFieldDidEndEditing?(textField)
    }
    
    private func reloadTable(){
        if let dataSource = self.tableDataSource, !dataSource.isEmpty{
            tableView.reloadData()
            if tableView.isHidden{
                tableView.isHidden = false
                let tableHeight = CGFloat(min(145, dataSource.count * 30))
                UIView.animate(withDuration: 0.25, animations: {
                    self.tableView.alpha = 1
                    self.tableView.frame.setHeight(height: tableHeight)
                })
            }
        }else{
            if !tableView.isHidden {
                UIView.animate(withDuration: 0.25, animations: {
                    self.tableView.alpha = 0
                    self.tableView.frame.setHeight(height: 0)
                }, completion: { (_) in
                    self.tableView.isHidden = true
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let text =  self.tableDataSource?[indexPath.row]{
            cell.textLabel?.attributedText = text.attributed(withSize: 13)            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        self.textField.text = self.tableDataSource?[indexPath.row]
        self.tableDataSource = nil
        self.reloadTable()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}
