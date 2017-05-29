//
//  CadastroPacienteVC.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 10/03/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class CadastroPacienteVC: CadastroBaseVC {
    
    @IBOutlet weak var nomeDoPacienteText: UITextField!
    @IBOutlet weak var especieDoPacientePicker: UIPickerView!
    @IBOutlet weak var racaDoPacienteText: UITextField!
    @IBOutlet weak var idadeDoPacientePicker: UIPickerView!
    @IBOutlet weak var fichaDoPacienteText: UITextField!
    @IBOutlet weak var chipDoPacienteText: UITextField!
    @IBOutlet weak var proprietarioDoPacienteLabel: UILabel!
    @IBOutlet weak var sexoDoPacienteSegment: UISegmentedControl!
    @IBOutlet weak var pacienteCastradoSegment: UISegmentedControl!
    @IBOutlet weak var pacienteObitoSegment: UISegmentedControl!
    @IBOutlet weak var altaDoPacienteText: UITextField!
    @IBOutlet weak var altaDoPacienteSegment: UISegmentedControl!
    @IBOutlet weak var canilDoPacientePicker: UIPickerView!
    
    var novoAnimal: Animal? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func saveUpdates() -> Bool {
        print("VAI SALVAR O ANIMAL!")
        return true
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
