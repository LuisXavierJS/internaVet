//
//  IndividuoMainCell.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 18/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class PacienteMainCell: UITableViewCell {
    @IBOutlet var especieDoPacienteLabel: UILabel!
    @IBOutlet var nomeDoPacienteLabel: UILabel!
    @IBOutlet var racaDoPacienteLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(withPaciente paciente: Animal){
        self.especieDoPacienteLabel.text = paciente.especie
        self.nomeDoPacienteLabel.text = paciente.nomeAnimal
        self.racaDoPacienteLabel.text = paciente.raca        
    }

}
