//
//  CadastroMedicacao.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 10/03/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CadastroMedicacaoVC: CadastroBaseVC, UIPickerViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var tipoDeTarefaPicker: UIPickerView!{
        didSet{
            tipoDeTarefaPickerDataSource = PickerViewDataSourceTiposTarefa(delegate: self, pickerView: tipoDeTarefaPicker)
        }
    }
    @IBOutlet weak var nomeDaTarefaLabel: UILabel!
    @IBOutlet weak var nomeDaTarefaText: UITextField!
    @IBOutlet weak var doseTaTarefaText: UITextField!{
        didSet{
            doseDaMedicacaoDelegate = TextFieldDelegateApenasNumeros(delegate: self, textField: doseTaTarefaText)
            doseDaMedicacaoDelegate?.limiteDeCaracteres = 3
        }
    }
    @IBOutlet weak var doseDaTarefaSegment: UISegmentedControl!
    @IBOutlet weak var doseDaTarefaView: UIView!
    @IBOutlet weak var intervaloEntreAplicacoesPicker: UIPickerView!{
        didSet{
            intervaloDeTarefaPickerDataSource = PickerViewDataSourceIntervalosDaTarefa(delegate: self, pickerView: intervaloEntreAplicacoesPicker)
        }
    }
    @IBOutlet weak var inicioTratamentoLabel: UILabel!
    @IBOutlet weak var inicioTratamentoView: UIView!
    @IBOutlet weak var inicioTratamentoDatePicker: UIDatePicker!{
        didSet{
            inicioTratamentoDatePicker.minimumDate = Date()
            inicioTratamentoDatePicker.maximumDate = Date().addingTimeInterval(60*60*24*31*12)
            inicioTratamentoDatePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        }
    }
    @IBOutlet weak var fimDoTratamentoLabel: UILabel!
    @IBOutlet weak var fimDoTratamentoView: UIView!
    @IBOutlet weak var fimDoTratamentoDatePicker: UIDatePicker!{
        didSet{
            fimDoTratamentoDatePicker.minimumDate = Date()
            fimDoTratamentoDatePicker.maximumDate = Date().addingTimeInterval(60*60*24*31*12)
            fimDoTratamentoDatePicker.addTarget(self, action: #selector(datePickerChanged), for: .valueChanged)
        }
    }
    @IBOutlet weak var observacoesText: UITextView!
    
    var tipoDeTarefaPickerDataSource: PickerViewDataSourceTiposTarefa? = nil
    var intervaloDeTarefaPickerDataSource: PickerViewDataSourceIntervalosDaTarefa? = nil
    var doseDaMedicacaoDelegate: TextFieldDelegateApenasNumeros? = nil
    
    weak var medicacao: Tarefa? = nil
    
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
        }
        let nsString = NSString(string: self.nomeDaTarefaLabel.text!)
        let sub = nsString.substring(from: 8)
        self.nomeDaTarefaLabel.text = self.nomeDaTarefaLabel.text?.replacingOccurrences(of: sub, with: self.tipoDeTarefaPicker.selectedTitle(inComponent: 0)!)
        // Do any additional setup after loading the view.
    }
    
    func setupFieldsFromMedicacao(){
        //selecionar pickers
        //selecionar datepickers
        //atribuir textfields
        //atribuir labels
        //atribuir textviews
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inicioTratamentoButtonTapped(_ sender: UIButton) {
        self.animateViewHideOrShow(view: self.inicioTratamentoView)
    }

    @IBAction func fimTratamentoButtonTapped(_ sender: UIButton) {
        self.animateViewHideOrShow(view: self.fimDoTratamentoView)
    }
    
    private func animateViewHideOrShow(view:UIView, forceHide: Bool? = nil){
        if view.isHidden == forceHide ?? !view.isHidden {return}
        UIView.animate(withDuration: 0.3) {
            view.isHidden = forceHide ?? !view.isHidden
            view.alpha = forceHide ?? view.isHidden ? 0 : 1
            self.view.layoutIfNeeded()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.tipoDeTarefaPicker{
            let shouldHide = self.tipoDeTarefaPicker.selectedTitle(inComponent: 0) != "Medicamento"
            self.animateViewHideOrShow(view: self.doseDaTarefaView,forceHide: shouldHide)
            let nsString = NSString(string: self.nomeDaTarefaLabel.text!)
            let sub = nsString.substring(from: 8)
            self.nomeDaTarefaLabel.text = self.nomeDaTarefaLabel.text?.replacingOccurrences(of: sub, with: self.tipoDeTarefaPicker.selectedTitle(inComponent: 0)!)
        }
    }
    
    func datePickerChanged(_ datePicker: UIDatePicker){
        if datePicker == self.inicioTratamentoDatePicker{
            let date = self.inicioTratamentoDatePicker.date as NSDate
            self.inicioTratamentoLabel.text = date.toString(withFormat: "HH:mm'h', dd/MM/yyyy")
            if fimDoTratamentoDatePicker.date < self.inicioTratamentoDatePicker.date {
                self.fimDoTratamentoLabel.text = date.toString(withFormat: "HH:mm'h', dd/MM/yyyy")
            }
            self.fimDoTratamentoDatePicker.minimumDate = date as Date
        }else{
            let date = self.fimDoTratamentoDatePicker.date as NSDate
            self.fimDoTratamentoLabel.text = date.toString(withFormat: "HH:mm'h', dd/MM/yyyy")
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
