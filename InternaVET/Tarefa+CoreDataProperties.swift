//
//  Tarefa+CoreDataProperties.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import CoreData


extension Tarefa {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tarefa> {
        return NSFetchRequest<Tarefa>(entityName: "Tarefa");
    }

    @NSManaged public var idTarefa: String?
    @NSManaged public var idAnimal: String?
    @NSManaged public var tipoTarefa: String?
    @NSManaged public var nomeTarefa: String?
    @NSManaged public var quantidadeDoseTarefa: String?
    @NSManaged public var tipoDoseTarefa: String?
    @NSManaged public var observacoesTarefa: String?
    @NSManaged public var inicioDaTarefa: NSDate?
    @NSManaged public var fimDaTarefa: NSDate?
    @NSManaged public var intervaloEntreExecucoes: Double
    @NSManaged public var idToque: String?

}
