//
//  CadastroPacienteVC.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 10/03/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CadastroPacienteVC: CadastroBaseVC, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var nomeDoPacienteText: UITextField!
    @IBOutlet weak var especieDoPacientePicker: UIPickerView!{
        didSet{
            self.especieDoPacientePickerDataSource = PickerViewDataSourceDeEspecies(delegate: self, pickerView: especieDoPacientePicker)
        }
    }
    @IBOutlet weak var racaDoPacienteText: UITextField!
    @IBOutlet weak var idadeDoPacientePicker: UIPickerView!{
        didSet{
            self.idadeDoPAcientePickerDataSource = PickerViewDataSourceDeIdade(delegate: self, pickerView: idadeDoPacientePicker)
        }
    }
    @IBOutlet weak var fichaDoPacienteText: UITextField!
    @IBOutlet weak var chipDoPacienteText: UITextField!
    @IBOutlet weak var proprietarioDoPacienteLabel: UILabel!
    @IBOutlet weak var sexoDoPacienteSegment: UISegmentedControl!
    @IBOutlet weak var pacienteCastradoSegment: UISegmentedControl!
    @IBOutlet weak var pacienteObitoSegment: UISegmentedControl!
    @IBOutlet weak var altaDoPacienteText: UITextField!{
        didSet{
            altaDoPacienteText.keyboardType = .numbersAndPunctuation
            self.altaDoPacienteTextFieldDelegate = TextFieldDelegateApenasNumeros(delegate: self, textField: altaDoPacienteText)
            self.altaDoPacienteTextFieldDelegate?.limiteDeCaracteres = 2
        }
    }
    @IBOutlet weak var altaDoPacienteSegment: UISegmentedControl!
    @IBOutlet weak var canilDoPacientePicker: UIPickerView!{
        didSet{
            self.canilDoPacientePickerDataSource = PickerViewDataSourceDeCanil(delegate: self, pickerView: canilDoPacientePicker)
        }
    }
    
    var especieDoPacientePickerDataSource: PickerViewDataSourceDeEspecies? = nil
    var idadeDoPAcientePickerDataSource: PickerViewDataSourceDeIdade? = nil
    var canilDoPacientePickerDataSource: PickerViewDataSourceDeCanil? = nil
    var altaDoPacienteTextFieldDelegate: TextFieldDelegateApenasNumeros? = nil
    
    var animal: Animal? = nil
    var proprietarioDoAnimal: Proprietario? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func validarCampos()->Bool{
        return false
    }
    
    private func calcularTempoDeAlta()->TimeInterval{
        let tempoInternacao = Double(self.altaDoPacienteText.text!) ?? 0
        let tipoTempoInternacao: Double = self.altaDoPacienteSegment.selectedSegmentIndex == 0 ? 1 : 24
        return tempoInternacao * tipoTempoInternacao * 60 * 60
    }
    
    override func saveUpdates() -> Bool {
        print("VAI SALVAR O ANIMAL!")
        if !validarCampos(){return false}
        let animal: Animal = self.animal ?? AnimalDAO.createAnimal()
        animal.nomeAnimal = self.nomeDoPacienteText.text
        animal.especie = self.especieDoPacientePicker.selectedTitle(inComponent: 0)
        animal.raca = self.racaDoPacienteText.text
        animal.idade = self.especieDoPacientePicker.selectedTitle(inComponent: 0)
        animal.idAnimal = self.fichaDoPacienteText.text
        animal.numeroChip = self.chipDoPacienteText.text
        animal.idProprietario = self.proprietarioDoAnimal?.idProprietario
        animal.sexo = self.sexoDoPacienteSegment.selectedTitle()
        animal.castrado = self.pacienteCastradoSegment.selectedTitle()
        animal.obito = self.pacienteObitoSegment.selectedTitle()
        animal.alta = NSDate().addingTimeInterval(self.calcularTempoDeAlta())
        animal.canil = Int64(self.canilDoPacientePicker.selectedRow(inComponent: 0))
        return true
    }

    @IBAction func selecionarProprietário(){
        if let proprietarioController = ListaProprietariosVC.instantiate(){
            self.navigationController?.pushViewController(proprietarioController, animated: true)
        }
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
