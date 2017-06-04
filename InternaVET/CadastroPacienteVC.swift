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
    @IBOutlet weak var racaDoPacienteText: UITextField!{
        didSet{
            self.racaDoPacienteTextFieldDelegate = TextFieldDelegateAutoComplete(tipoComplete: .CanisFamiliaris, delegate: self, textField: racaDoPacienteText)
        }
    }
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
    var racaDoPacienteTextFieldDelegate: TextFieldDelegateAutoComplete? = nil
    
    var animal: Animal? = nil
    var proprietarioDoAnimal: Proprietario? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let animal = self.animal{
            self.setarCamposParaPacienteAtual(paciente: animal)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.proprietarioDoPacienteLabel.text = self.proprietarioDoAnimal?.nome
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setarCamposParaPacienteAtual(paciente: Animal){
        self.fichaDoPacienteText.isUserInteractionEnabled = false
        self.fichaDoPacienteText.text = paciente.idAnimal
        self.nomeDoPacienteText.text = paciente.nomeAnimal
        self.racaDoPacienteText.text = paciente.raca
        self.altaDoPacienteText.text = paciente.tempoDeAltaText()
        let indexSegment = paciente.tipoDeAlta()?.localizedCaseInsensitiveContains("hora") ?? true ? 0 : 1
        self.altaDoPacienteSegment.selectedSegmentIndex = indexSegment
        self.especieDoPacientePicker.selectTitle(title: paciente.especie!, inComponent: 0)
        self.idadeDoPacientePicker.selectTitle(title: paciente.idade!, inComponent: 0)
        if paciente.canilInt > 0 {
            self.canilDoPacientePickerDataSource?.insertCanil(numeroCanil: paciente.canilInt)
            self.canilDoPacientePicker.reloadAllComponents()
            self.canilDoPacientePicker.selectTitle(title: paciente.canilStr, inComponent: 0)
        }
        if let idProprietario = paciente.idProprietario{
            self.proprietarioDoAnimal = ProprietarioDAO.fetchProprietario(fromIdProprietario: idProprietario)
        }
    }
    
    private func validarCamposObrigatorios()->Bool{
        let areValid = !(self.nomeDoPacienteText.text!.isEmpty ||
            self.racaDoPacienteText.text!.isEmpty ||
            self.fichaDoPacienteText.text!.isEmpty)
        if !areValid {
            self.presentAlert(title: "Preenchimento Incompleto!", message: "Todos os campos obrigatórios (com asterístico) devem ser preenchidos!")
        }
        return areValid
    }
    
    private func validarFichaAnimal()->Bool{
        if self.animal != nil {return true}
        let animal = AnimalDAO.fetchAnimal(fromIdAnimal: self.fichaDoPacienteText.text!)
        let isValid = animal == nil
        if !isValid{
            self.presentAlert(title: "Preenchimento Inválido!", message: "Já existe um paciente com essa ficha!")
        }
        return isValid
    }
    
    private func setarDadosDoAnimal(){
        let animal: Animal = self.animal ?? AnimalDAO.createAnimal()
        if self.animal == nil {
            animal.dataDoCadastro = NSDate()
            animal.idAnimal = self.fichaDoPacienteText.text
        }else{
            if animal.canilInt > 0{
                CanilDAO.liberarCanilDeIndex(index: animal.canilInt - 1)
            }
        }
        animal.nomeAnimal = self.nomeDoPacienteText.text
        animal.especie = self.especieDoPacientePicker.selectedTitle(inComponent: 0)
        animal.raca = self.racaDoPacienteText.text
        animal.idade = self.idadeDoPacientePicker.selectedTitle(inComponent: 0)
        animal.numeroChip = self.chipDoPacienteText.text
        animal.idProprietario = self.proprietarioDoAnimal?.idProprietario
        animal.sexo = self.sexoDoPacienteSegment.selectedTitle()
        animal.castrado = self.pacienteCastradoSegment.selectedTitle()
        animal.obito = self.pacienteObitoSegment.selectedTitle()
        animal.altaString = self.altaDoPacienteText.text! + "." + self.altaDoPacienteSegment.selectedTitle()!
        let canilIndex = self.canilDoPacientePicker.selectedRow(inComponent: 0)
        if canilIndex > 0 {
            CanilDAO.ocuparCanilDeIndex(index: canilIndex - 1)
        }
        animal.canil = Int64(canilIndex)
    }
    
    override func saveUpdates() -> Bool {
        print("VAI SALVAR O ANIMAL!")
        if validarCamposObrigatorios() && validarFichaAnimal(){
            self.setarDadosDoAnimal()
            if let raca = self.racaDoPacienteText.text{
                AutoCompleteDataSource.inserirStringCasoNaoExista(string: raca, paraCompletar: getTipoDeCompletadorSelecionado())
            }
            CoreDataManager.saveContext("Salvando paciente de nome \(String(describing: animal?.nomeAnimal)) e ficha \(String(describing: animal?.idAnimal))")
            return true
        }
        return false
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.especieDoPacientePicker{
           self.racaDoPacienteTextFieldDelegate?.setTipoComplete(novoTipo: self.getTipoDeCompletadorSelecionado())
        }
    }

    private func getTipoDeCompletadorSelecionado()->TipoDeCompletador{
        if let selectedTitle = especieDoPacientePicker.selectedTitle(inComponent: 0){
            if selectedTitle.localizedCaseInsensitiveContains("canis"){
                return .CanisFamiliaris
            }else{
                return .FelisCatus
            }
        }
        return .CanisFamiliaris
    }
    
    @IBAction func selecionarProprietário(){
        let listaDeModelos = ListaDeModelosVC<Proprietario>()
        listaDeModelos.dataList = ProprietarioDAO.fetchAll()
        listaDeModelos.didSelectClosure = { (proprietario) in
            self.proprietarioDoAnimal = proprietario
            self.proprietarioDoPacienteLabel.text = proprietario.nome
        }
        self.navigationController?.pushViewController(listaDeModelos, animated: true)
    }

}
