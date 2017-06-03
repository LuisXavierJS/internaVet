//
//  CadastroProprietarioVC.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 10/03/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CadastroProprietarioVC: CadastroBaseVC {
    @IBOutlet weak var nomeProprietarioText: UITextField!
    @IBOutlet weak var telefoneProprietarioText: UITextField!
    @IBOutlet weak var emailProprietarioText: UITextField!
    @IBOutlet weak var enderecoProprietarioText: UITextField!
    
    weak var proprietario: Proprietario? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.proprietario != nil {
            self.setupFieldsFromProprietario()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupFieldsFromProprietario(){
        self.enderecoProprietarioText.text = self.proprietario?.endereco
        self.emailProprietarioText.text = self.proprietario?.email
        self.nomeProprietarioText.text = self.proprietario?.nome
        self.telefoneProprietarioText.text = self.proprietario?.telefone
    }
    
    func validarCamposObrigatorios()->Bool{
        let areValid = !(self.nomeProprietarioText.text!.isEmpty)
        if !areValid {
            self.presentAlert(title: "Preenchimento Incompleto!", message: "Todos os campos obrigatórios (com asterístico) devem ser preenchidos!")
        }
        return areValid    }
    
    func setarDadosDoProprietario(){
        let proprietario = self.proprietario ?? ProprietarioDAO.createProprietario()
        if self.proprietario == nil {
            proprietario.idProprietario = NSDate().toString(withFormat: "HHmmhhyyyyMMddsszzz")
        }
        proprietario.nome = self.nomeProprietarioText.text
        proprietario.email = self.emailProprietarioText.text
        proprietario.telefone = self.telefoneProprietarioText.text
        proprietario.endereco = self.enderecoProprietarioText.text
    }
    
    override func saveUpdates() -> Bool {
        if validarCamposObrigatorios(){
            self.setarDadosDoProprietario()
            CoreDataManager.saveContext("Salvando proprietario de nome \(self.nomeProprietarioText.text)")
            return true
        }
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
