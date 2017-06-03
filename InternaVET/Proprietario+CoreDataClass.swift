//
//  Proprietario+CoreDataClass.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import CoreData


public class Proprietario: NSManagedObject, TableDataProtocol {
    var animais: [Animal] {
        guard let idProp = self.idProprietario else {return []}
        return AnimalDAO.fetchAnimais(fromIdProprietario: idProp)
    }
    
    func getDados()->String{
        return (self.nome ?? "") + ", " + (self.email ?? "") + (self.telefone ?? "")
    }
    
    func getTitle() -> String {
        return self.nome ?? " -- "
    }
    
    func getSubTitle() -> String {
        return self.celular ?? " -- "
    }
}
