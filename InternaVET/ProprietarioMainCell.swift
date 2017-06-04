//
//  ProprietarioMainCell.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 03/06/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ProprietarioMainCell: UITableViewCell {
    @IBOutlet weak var nomeProprietario: UILabel!
    @IBOutlet weak var celularProprietario: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(withProprietario proprietario: Proprietario){
        self.nomeProprietario.text = proprietario.nome
        self.celularProprietario.text = proprietario.celular
    }

}
