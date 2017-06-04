//
//  ProprietarioBodyCell.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 03/06/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ProprietarioBodyCell: UITableViewCell {
    @IBOutlet weak var emailProprietarioLabel: UILabel!
    @IBOutlet weak var enderecoProprietarioLabel: UILabel!
    @IBOutlet weak var listaDePacientesLabel: UILabel!
    @IBOutlet weak var telefoneLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setup(withProprietario proprietario: Proprietario){
        self.emailProprietarioLabel.attributedText = "".attributed()
        self.enderecoProprietarioLabel.attributedText = "".attributed()
        self.telefoneLabel.attributedText = "".attributed()
        self.listaDePacientesLabel.attributedText = "".attributed()
        
        let boldSize: CGFloat = 14
        if let email = proprietario.email, !email.isEmpty{
            let attrText = "Email: "
            let emailText = attrText + email
            self.emailProprietarioLabel.attributedText = emailText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        if let endereco = proprietario.endereco, !endereco.isEmpty{
            let attrText = "Endereço: "
            let enderecoText = attrText + endereco
            self.enderecoProprietarioLabel.attributedText = enderecoText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        if let telefone = proprietario.telefone, !telefone.isEmpty{
            let attrText = "Telefone: "
            let telefoneText = attrText + telefone
            self.telefoneLabel.attributedText = telefoneText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
        let animais = proprietario.animais
        if animais.count > 0 {
            let attrText = "Animais deste proprietário: "
            var animaisString: String = ""
            for animalIndex in 0..<animais.count{
                animaisString+=animais[animalIndex].nomeAnimal! + (animalIndex < animais.count - 1 ? "," : "")
            }
            let pacientesText = attrText + animaisString
            self.listaDePacientesLabel.attributedText = pacientesText.bold(boldPartsOfString: [attrText], boldSize: boldSize)
        }
    }
}
