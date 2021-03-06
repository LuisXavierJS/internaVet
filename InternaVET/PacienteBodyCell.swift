//
//  IndividuoBodyCell.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 18/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class PacienteBodyCell: UITableViewCell {
    @IBOutlet var idadeLabel: UILabel!
    @IBOutlet var proprietarioLabel: UILabel!
    @IBOutlet var sexoLabel: UILabel!
    @IBOutlet var castradoLabel: UILabel!
    @IBOutlet var fichaLabel: UILabel!
    @IBOutlet var canilLabel: UILabel!
    @IBOutlet var chipLabel: UILabel!
    @IBOutlet var tempoRestanteInternacaoLabel: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(withPaciente paciente: Animal){
        self.idadeLabel.attributedText = "".attributed()
        self.proprietarioLabel.attributedText = "".attributed()
        self.sexoLabel.attributedText = "".attributed()
        self.castradoLabel.attributedText = "".attributed()
        self.fichaLabel.attributedText = "".attributed()
        self.chipLabel.attributedText = "".attributed()
        self.canilLabel.attributedText = "".attributed()
        self.tempoRestanteInternacaoLabel.attributedText = "".attributed()
        
        let boldSize: CGFloat = 14
        if let idade = paciente.idade, !idade.isEmpty{
            let attrText = "Idade: "
            let idadeText = attrText + idade
            self.idadeLabel.attributedText = idadeText.attributed.bold(boldPartsOfString: [attrText], size: boldSize)
        }
        if let propName = paciente.proprietario?.nome, !propName.isEmpty{
            let attrText = "Proprietário: "
            let propText = attrText + propName
            self.proprietarioLabel.attributedText = propText.attributed.bold(boldPartsOfString: [attrText], size: boldSize)
        }
        if let sexo = paciente.sexo, !sexo.isEmpty{
            let attrText = "Sexo: "
            let sexoText = attrText + sexo
            self.sexoLabel.attributedText = sexoText.attributed.bold(boldPartsOfString: [attrText], size: boldSize)
        }
        if let castrado = paciente.castrado, !castrado.isEmpty{
            let attrText = "Castrado: "
            let castradoText = attrText + castrado
            self.castradoLabel.attributedText = castradoText.attributed.bold(boldPartsOfString: [attrText], size: boldSize)
        }
        if let ficha = paciente.idAnimal, !ficha.isEmpty{
            let attrText = "Ficha: "
            let fichaText = attrText + ficha
            self.fichaLabel.attributedText = fichaText.attributed.bold(boldPartsOfString: [attrText], size: boldSize)
        }
        if let chip = paciente.numeroChip, !chip.isEmpty{
            let attrText = "Chip: "
            let chipText = attrText + chip
            self.chipLabel.attributedText = chipText.attributed.bold(boldPartsOfString: [attrText], size: boldSize)
        }
        if let tempoRestante = paciente.tempoRestanteDeInternacao(), !tempoRestante.isEmpty{
            let attrText = "Tempo restante de internação: "
            let tempoRestanteText = attrText + tempoRestante
            self.tempoRestanteInternacaoLabel.attributedText = tempoRestanteText.attributed.bold(boldPartsOfString: [attrText], size: boldSize)
        }
        let attrText = "Canil: "
        let canilText = attrText + paciente.canilStr
        self.canilLabel.attributedText = canilText.attributed.bold(boldPartsOfString: [attrText], size: boldSize)
        
    }
    
}
