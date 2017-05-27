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
    @IBOutlet weak var nomeDoAnimalLabel: UILabel!
    @IBOutlet weak var racaDoAnimalLabel: UILabel!
    var isShowingBodyCell: Bool = false
    weak var tarefa: TarefaDataProtocol? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
