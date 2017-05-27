//
//  Animal+CoreDataProperties.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import CoreData


extension Animal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Animal> {
        return NSFetchRequest<Animal>(entityName: "Animal");
    }

    @NSManaged public var idAnimal: String?
    @NSManaged public var idProprietario: String?
    @NSManaged public var numeroChip: String?
    @NSManaged public var sexo: String?
    @NSManaged public var castrado: Bool
    @NSManaged public var obito: Bool
    @NSManaged public var alta: Int64
    @NSManaged public var canil: Int64
    @NSManaged public var raca: String?
    @NSManaged public var especie: String?
    @NSManaged public var nomeFotoAnimal: String?
    @NSManaged public var idade: Int64

}
