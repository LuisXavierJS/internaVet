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
    @IBOutlet weak var nomeDaTarefaText: UITextField!
    @IBOutlet weak var doseTaTarefaText: UITextField!{
        didSet{
            doseDaMedicacaoDelegate = TextFieldDelegateApenasNumeros(delegate: self, textField: doseTaTarefaText)
            doseDaMedicacaoDelegate?.limiteDeCaracteres = 3
        }
    }
    @IBOutlet weak var doseDaTarefaSegment: UISegmentedControl!
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
        }
    }
    @IBOutlet weak var fimDoTratamentoLabel: UILabel!
    @IBOutlet weak var fimDoTratamentoView: UIView!
    @IBOutlet weak var fimDoTratamentoDatePicker: UIDatePicker!{
        didSet{
            fimDoTratamentoDatePicker.minimumDate = Date()
            fimDoTratamentoDatePicker.maximumDate = Date().addingTimeInterval(60*60*24*31*12)
        }
    }
    @IBOutlet weak var observacoesText: UITextView!
    
    var tipoDeTarefaPickerDataSource: PickerViewDataSourceTiposTarefa? = nil
    var intervaloDeTarefaPickerDataSource: PickerViewDataSourceIntervalosDaTarefa? = nil
    var doseDaMedicacaoDelegate: TextFieldDelegateApenasNumeros? = nil
    
    weak var medicacao: Tarefa? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    private func animateViewHideOrShow(view:UIView){
        UIView.animate(withDuration: 0.3) {
            view.isHidden = !view.isHidden
            view.alpha = view.isHidden ? 0 : 1
            self.view.layoutIfNeeded()
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
