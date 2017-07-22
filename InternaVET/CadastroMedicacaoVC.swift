//
//  CadastroMedicacao.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 10/03/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CadastroMedicacaoVC: CadastroBaseVC, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tipoDeTarefaPicker: UIPickerView!{
        didSet{
            tipoDeTarefaPickerDataSource = PickerViewDataSourceTiposTarefa(delegate: self, pickerView: tipoDeTarefaPicker)
        }
    }
    @IBOutlet weak var nomeDaTarefaLabel: UILabel!
    @IBOutlet weak var nomeDaTarefaText: UITextField!{
        didSet{
            self.nomeDaTarefaDelegateAutoComplete = TextFieldDelegateAutoComplete(tipoComplete: .Medicamento, delegate: self, textField: nomeDaTarefaText)            
        }
    }
    @IBOutlet weak var doseTaTarefaText: UITextField!{
        didSet{
            doseDaMedicacaoDelegate = TextFieldDelegateApenasNumeros(delegate: self, textField: doseTaTarefaText)
            doseDaMedicacaoDelegate?.limiteDeCaracteres = 3
        }
    }
    @IBOutlet weak var doseDaTarefaHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var doseDaTarefaSegment: UISegmentedControl!
    @IBOutlet weak var doseDaTarefaView: UIView!
    @IBOutlet weak var intervaloEntreAplicacoesPicker: UIPickerView!{
        didSet{
            intervaloDeTarefaPickerDataSource = PickerViewDataSourceIntervalosDaTarefa(delegate: self, pickerView: intervaloEntreAplicacoesPicker)
        }
    }
    @IBOutlet weak var nomeDoPacienteLabel: UILabel!
    @IBOutlet weak var inicioTratamentoLabel: UILabel!
    @IBOutlet weak var fimDoTratamentoLabel: UILabel!
    @IBOutlet weak var observacoesText: UITextView!{
        didSet{
            observacoesText.layer.borderColor = UIColor.mediumGreen.cgColor
            observacoesText.delegate = self
        }
    }
    
    lazy var datePickerView: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.isHidden = true
        datePicker.locale = Calendar.current.locale
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(60*60*24*31*3)
        datePicker.addTarget(self, action: #selector(datePickerHadChanged), for: .valueChanged)
        return datePicker
    }()
    var dataDeInicioDoTratamento: Date = Date()
    var dataDoFimDoTratamento:Date = Date()
    
    
    var tipoDeTarefaPickerDataSource: PickerViewDataSourceTiposTarefa? = nil
    var intervaloDeTarefaPickerDataSource: PickerViewDataSourceIntervalosDaTarefa? = nil
    var doseDaMedicacaoDelegate: TextFieldDelegateApenasNumeros? = nil
    var nomeDaTarefaDelegateAutoComplete: TextFieldDelegateAutoComplete? = nil
    private var novaMedicacao: Tarefa?
    weak var medicacao: Tarefa? = nil
    var animal: Animal? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if medicacao == nil {
            self.inicioTratamentoLabel.text = NSDate().toString(withFormat: "HH:mm'h', dd/MM/yyyy")
            self.fimDoTratamentoLabel.text = NSDate().toString(withFormat: "HH:mm'h', dd/MM/yyyy")
        }else{
            self.setupFieldsFromMedicacao()
        }
        
        if self.tipoDeTarefaPicker.selectedTitle(inComponent: 0) == "Medicamento" {
            self.doseDaTarefaView.isHidden = false
            self.doseDaTarefaHeightContraint.constant = 50
        }else{
            self.doseDaTarefaView.isHidden = true
            self.doseDaTarefaHeightContraint.constant = 0
        }
        let nsString = NSString(string: self.nomeDaTarefaLabel.text!)
        let sub = nsString.substring(from: 8)
        self.nomeDaTarefaLabel.text = self.nomeDaTarefaLabel.text?.replacingOccurrences(of: sub, with: " " + self.tipoDeTarefaPicker.selectedTitle(inComponent: 0)!)
        self.registerForKeyboardEvents()
        // Do any additional setup after loading the view.
    }
    
    func setupFieldsFromMedicacao(){
        guard let medicacao = self.medicacao else {return}
        self.tipoDeTarefaPicker.selectTitle(title: medicacao.tipoTarefa!, inComponent: 0)
        self.intervaloEntreAplicacoesPicker.selectRow(Int(medicacao.intervaloEntreExecucoes), inComponent: 0, animated: false)
        self.doseTaTarefaText.text = medicacao.quantidadeDoseTarefa
        self.nomeDoPacienteLabel.text = medicacao.animal?.nomeAnimal
        self.nomeDaTarefaText.text = medicacao.nomeTarefa
        self.observacoesText.text = medicacao.observacoesTarefa
        if let date = medicacao.inicioDaTarefa{
         self.dataDeInicioDoTratamento = date as Date
        }
        if let date = medicacao.fimDaTarefa{
            self.dataDoFimDoTratamento = date as Date
        }
        self.inicioTratamentoLabel.text = (medicacao.inicioDaTarefa ?? NSDate()).toString(withFormat: "HH:mm'h', dd/MM/yyyy")
        self.fimDoTratamentoLabel.text = (medicacao.fimDaTarefa ?? NSDate()).toString(withFormat: "HH:mm'h', dd/MM/yyyy")
        self.doseDaTarefaSegment.selectTitle(title: medicacao.tipoDoseTarefa ?? "")
        self.tipoDeTarefaPicker.isUserInteractionEnabled = false
        self.animal = medicacao.animal
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inicioTratamentoButtonTapped(_ sender: UIButton) {
        self.datePickerView.isHidden = false
        self.datePickerView.minimumDate = Date()
        self.datePickerView.date = self.dataDeInicioDoTratamento
        self.datePickerView.accessibilityIdentifier = "inicioTratamentoView"
        self.showBottomInputPickerView(inputViewId: "inicioTratamentoView", inputView: self.datePickerView) { (_) in
        }
    }

    @IBAction func fimTratamentoButtonTapped(_ sender: UIButton) {
        self.datePickerView.isHidden = false
        self.datePickerView.minimumDate = self.dataDeInicioDoTratamento
        self.datePickerView.date = self.dataDoFimDoTratamento
        self.datePickerView.accessibilityIdentifier = "fimTratamentoView"
        self.showBottomInputPickerView(inputViewId: "fimTratamentoView", inputView: self.datePickerView) { (_) in
        }
    }
    
    func datePickerHadChanged(){
        if let identifier = self.datePickerView.accessibilityIdentifier{
            self.datePickerChanged(forId: identifier)
        }
    }
    
    func datePickerChanged(forId: String){
        if forId == "inicioTratamentoView"{
            self.dataDeInicioDoTratamento = self.datePickerView.date
            let date = self.dataDeInicioDoTratamento as NSDate
            self.inicioTratamentoLabel.text = date.toString(withFormat: "HH:mm'h', dd/MM/yyyy")
            if self.dataDoFimDoTratamento < self.dataDeInicioDoTratamento {
                self.fimDoTratamentoLabel.text = date.toString(withFormat: "HH:mm'h', dd/MM/yyyy")
            }
            self.dataDoFimDoTratamento = self.dataDeInicioDoTratamento
        }else{
            self.dataDoFimDoTratamento = self.datePickerView.date
            let date = self.dataDoFimDoTratamento as NSDate
            self.fimDoTratamentoLabel.text = date.toString(withFormat: "HH:mm'h', dd/MM/yyyy")
        }
    }
    
    
    private func animateViewHideOrShow(view:UIView, forceHide: Bool? = nil, completion: ((Bool) -> Void)? = nil){
        if view.isHidden == forceHide ?? !view.isHidden {return}
        UIView.animate(withDuration: 0.3, animations: { 
            view.isHidden = forceHide ?? !view.isHidden
            view.alpha = forceHide ?? view.isHidden ? 0 : 1
            self.view.layoutIfNeeded()
        }, completion: completion)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.tipoDeTarefaPicker{
            let shouldHide = self.tipoDeTarefaPicker.selectedTitle(inComponent: 0) != "Medicamento"
            self.doseDaTarefaHeightContraint.constant = shouldHide ? 0 : 50
            self.animateViewHideOrShow(view: self.doseDaTarefaView,forceHide: shouldHide)
            let nsString = NSString(string: self.nomeDaTarefaLabel.text!)
            let sub = nsString.substring(from: 8)
            self.nomeDaTarefaLabel.text = self.nomeDaTarefaLabel.text?.replacingOccurrences(of: sub, with: " " + self.tipoDeTarefaPicker.selectedTitle(inComponent: 0)!)
            self.nomeDaTarefaDelegateAutoComplete?.setTipoComplete(novoTipo: getTipoDeCompletador())
        }
    }
    
    func getTipoDeCompletador()->TipoDeCompletador{
        if let selectedTitle = self.tipoDeTarefaPicker.selectedTitle(inComponent: 0){
            if selectedTitle.localizedCaseInsensitiveContains("Medicamento"){
                return .Medicamento
            }else if selectedTitle.localizedCaseInsensitiveContains("Exame"){
                return .Exame
            }else{
                return .Procedimento
            }
        }
        return .Medicamento
    }
    
    func setarDadosDaMedicacao(){
        let tarefa = self.medicacao ?? TarefaDAO.createTarefa()
        if self.medicacao == nil {
            tarefa.idTarefa = NSDate().toString(withFormat: "hhHHmmMMyyyysszzz")
        }
        tarefa.nomeTarefa = self.nomeDaTarefaText.text
        tarefa.animal = self.animal
        tarefa.tipoTarefa = self.tipoDeTarefaPicker.selectedTitle(inComponent: 0)
        tarefa.intervaloEntreExecucoes = Double(self.intervaloEntreAplicacoesPicker.selectedRow(inComponent: 0))
        tarefa.inicioDaTarefa = self.dataDeInicioDoTratamento as NSDate
        tarefa.fimDaTarefa = self.dataDoFimDoTratamento as NSDate
        tarefa.observacoesTarefa = self.observacoesText.text
        tarefa.quantidadeDoseTarefa = self.doseTaTarefaText.text
        tarefa.tipoDoseTarefa = self.doseDaTarefaSegment.selectedTitle()
        tarefa.horarios = tarefa.getListaDeDosesPendentes()
        self.novaMedicacao = tarefa
    }
    
    func validarCamposObrigatorios()->Bool{
        let areValid = !(self.animal == nil ||
            self.nomeDaTarefaLabel.text!.isEmpty ||
            (self.doseTaTarefaText.text!.isEmpty &&
                self.tipoDeTarefaPicker.selectedTitle(inComponent: 0)! == "Medicamento"))
        if !areValid {
            self.presentAlert(title: "Preenchimento Incompleto!", message: "Todos os campos obrigatórios (com asterístico) devem ser preenchidos!")
        }
        return areValid
    }
    
    override func saveUpdates() -> Bool {
        if validarCamposObrigatorios() {
            self.setarDadosDaMedicacao()
            if let nomeTarefa = self.nomeDaTarefaText.text{
                AutoCompleteDataSource.inserirStringCasoNaoExista(string: nomeTarefa, paraCompletar: getTipoDeCompletador())
            }
            CoreDataManager.saveContext("Criando nova tarefa de nome \(String(describing: self.nomeDaTarefaLabel.text))")
            if let medicacao = self.novaMedicacao{
                GerenciadorDeTarefas.putNotification(forTarefa: medicacao)
            }
            return true
        }
        return false
    }
    
    @IBAction func selecionarPaciente(sender: UIButton){
        self.view.endEditing(true)
        let listaDeModelos = ListaDeModelosVC<Animal>()
        listaDeModelos.dataList = AnimalDAO.fetchAll()
        listaDeModelos.didSelectClosure = { (animal) in
            self.animal = animal
            self.nomeDoPacienteLabel.text = animal.nomeAnimal
        }
        listaDeModelos.title = "Selecione um Paciente"
        self.navigationController?.pushViewController(listaDeModelos, animated: true)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let position = CGPoint(x: 0, y: self.view.frame.bottomYLine)
        self.scrollView.setContentOffset(position, animated: true)
        return true
    }
    
    override func keyboardDidAppear(notification: NSNotification) {
        if !self.datePickerView.isHidden{
            let position = CGPoint(x: 0, y: self.observacoesText.frame.bottomYLine + 30)
            self.scrollView.setContentOffset(position, animated: true)
        }
    }

    override func keyboardDidDisappear(notification: NSNotification) {
        self.datePickerView.isHidden = true
    }
}
