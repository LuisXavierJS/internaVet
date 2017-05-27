//
//  Proprietario+CoreDataProperties.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import CoreData


extension Proprietario {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Proprietario> {
        return NSFetchRequest<Proprietario>(entityName: "Proprietario");
    }

    @NSManaged public var idProprietario: String?
    @NSManaged public var endereco: String?
    @NSManaged public var email: String?
    @NSManaged public var celular: String?
    @NSManaged public var telefone: String?
    @NSManaged public var nome: String?

}
