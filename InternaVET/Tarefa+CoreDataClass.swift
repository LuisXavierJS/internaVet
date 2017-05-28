//
//  Tarefa+CoreDataClass.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import CoreData


public class Tarefa: NSManagedObject, TarefaDataProtocol {
    lazy var animal: Animal? = {
        return AnimalDAO.getAnimal(fromIdAnimal: self.idAnimal!)
    }()
    func getNomeDoAnimal()->String?{
        return animal?.nomeAnimal
    }
    func getRacaDoAnimal()->String?{
        return animal?.raca
    }
    func getNomeDaTarefa()->String?{
        return nil
    }
    func getHoraDaTarefa()->String?{
        return nil
    }
    func getTipoDaTarefa()->String?{
        return nil
    }
    func getObservacoesDaTarefa()->String?{
        return nil
    }

}
