//
//  TarefaBodyCell.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 18/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class TarefaBodyCell: UITableViewCell {
    @IBOutlet weak var proprietarioLabel: UILabel!
    @IBOutlet weak var tipoDeTarefaLabel: UILabel!
    @IBOutlet weak var horaDaProximaDoseLabel: UILabel!
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
        let boldSize: CGFloat = 14
        if let nomeProp = tarefa.animal?.proprietario?.nome{
            let attrText = "Proprietário: "
            let propText = attrText + nomeProp
            self.proprietarioLabel.attributedText = propText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        if let tipoTarefa = tarefa.tipoTarefa{
            let attrText = "Tipo: "
            let tipoText = attrText + tipoTarefa
            self.tipoDeTarefaLabel.attributedText = tipoText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        if let proximaDose = tarefa.getHoraDaDoseSequente(){
            let attrText = "Próxima aplicação: "
            let doseText = attrText + proximaDose
            self.horaDaProximaDoseLabel.attributedText = doseText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        if let dataInicio = tarefa.inicioDaTarefa?.toString(){
            let attrText = "Início do Tratamento: "
            let inicioText = attrText + dataInicio
            self.dataInicioTratamentoLabel.attributedText = inicioText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        if let dataFim = tarefa.fimDaTarefa?.toString(){
            let attrText = "Fim do Tratamento: "
            let fimText = attrText + dataFim
            self.dataFimTratamentoLabel.attributedText = fimText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        if let observacoes = tarefa.observacoesTarefa{
            let attrText = "Observações: "
            let obsText = attrText + observacoes
            self.observacoesLabel.attributedText = obsText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        let attrText = "Intervalo entre Aplicações: "
        let intervaloText = attrText + tarefa.intervaloEntreAplicacoes()
        self.intervaloEntreAplicacoes.attributedText = intervaloText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
    }
}
