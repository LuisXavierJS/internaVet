//
//  TarefaBodyCell.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 18/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class TarefaBodyCell: UITableViewCell {
    @IBOutlet weak var pacienteLabel: UILabel!
    @IBOutlet weak var proprietarioLabel: UILabel!
    @IBOutlet weak var tipoDeTarefaLabel: UILabel!
    @IBOutlet weak var intervaloEntreAplicacoes: UILabel!
    @IBOutlet weak var dataInicioTratamentoLabel: UILabel!
    @IBOutlet weak var dataFimTratamentoLabel: UILabel!
    @IBOutlet weak var observacoesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(withTarefa tarefa: Tarefa){
        self.pacienteLabel.attributedText = "".attributed()
        self.proprietarioLabel.attributedText = "".attributed()
        self.tipoDeTarefaLabel.attributedText = "".attributed()
        self.dataInicioTratamentoLabel.attributedText = "".attributed()
        self.dataFimTratamentoLabel.attributedText = "".attributed()
        self.observacoesLabel.attributedText = "".attributed()
        
        let boldSize: CGFloat = 14
        if let paciente = tarefa.animal?.nomeAnimal{
            let attrText = "Paciente: "
            let pacienteText = attrText + paciente
            self.pacienteLabel.attributedText = pacienteText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        if let nomeProp = tarefa.animal?.proprietario?.nome, !nomeProp.isEmpty{
            let attrText = "Proprietário: "
            let propText = attrText + nomeProp
            self.proprietarioLabel.attributedText = propText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        if let tipoTarefa = tarefa.tipoTarefa, !tipoTarefa.isEmpty{
            let attrText = "Tipo: "
            let tipoText = attrText + tipoTarefa
            self.tipoDeTarefaLabel.attributedText = tipoText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        
        if let dataInicio = tarefa.inicioDaTarefa?.toString(), !dataInicio.isEmpty{
            let attrText = "Início do Tratamento: "
            let inicioText = attrText + dataInicio
            self.dataInicioTratamentoLabel.attributedText = inicioText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        if let dataFim = tarefa.fimDaTarefa?.toString(),!dataFim.isEmpty{
            let attrText = "Fim do Tratamento: "
            let fimText = attrText + dataFim
            self.dataFimTratamentoLabel.attributedText = fimText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        if let observacoes = tarefa.observacoesTarefa, !observacoes.isEmpty{
            let attrText = "Observações: "
            let obsText = attrText + observacoes
            self.observacoesLabel.attributedText = obsText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        let attrText = "Intervalo entre Aplicações: "
        let intervaloText = attrText + tarefa.intervaloEntreAplicacoes()
        self.intervaloEntreAplicacoes.attributedText = intervaloText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
    }
}
