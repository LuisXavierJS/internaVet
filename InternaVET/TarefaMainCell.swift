//
//  TarefaMainCell.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 16/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class TarefaMainCell: UITableViewCell {
    @IBOutlet var horarioLabel: UILabel!
    @IBOutlet var nomeTarefaLabel: UILabel!
    @IBOutlet var nomeDoAnimalLabel: UILabel!
    @IBOutlet var racaDoAnimalLabel: UILabel!
    @IBOutlet var separatorLineView: UIView!
    @IBOutlet var dadosGeraisLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
