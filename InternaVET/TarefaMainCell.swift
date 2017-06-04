//
//  TarefaMainCell.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 16/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class TarefaMainCell: UITableViewCell {
    @IBOutlet weak var horarioLabel: UILabel!
    @IBOutlet weak var nomeTarefaLabel: UILabel!
    @IBOutlet weak var racaDoAnimalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(withTarefa tarefa: Tarefa){
        self.horarioLabel.text = tarefa.getHoraDaTarefa()
        self.nomeTarefaLabel.text = tarefa.nomeTarefa
        self.racaDoAnimalLabel.text = tarefa.getRacaDoAnimal()
    }
    
}
