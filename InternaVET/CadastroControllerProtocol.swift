//
//  CadastroControllerProtocol.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 27/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@objc protocol CadastroControllerDelegate : class {

}

@objc protocol CadastroViewControllerProtocol {
    weak var delegate: CadastroControllerDelegate? {get set}
}

//public class Tarefa: NSManagedObject {
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tarefa> {
//        return NSFetchRequest<Tarefa>(entityName: "Tarefa");
//    }
//    
//    @NSManaged public var idTarefa: String?
//    @NSManaged public var idAnimal: String?
//    @NSManaged public var tipoTarefa: String?
//    @NSManaged public var nomeTarefa: String?
//    @NSManaged public var observacoesTarefa: String?
//    @NSManaged public var inicioDaTarefa: NSDate?
//    @NSManaged public var fimDaTarefa: NSDate?
//    @NSManaged public var intervaloEntreExecucoes: Double
//    @NSManaged public var idToque: String?
//}
