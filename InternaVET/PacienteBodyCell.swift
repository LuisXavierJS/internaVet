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

}
