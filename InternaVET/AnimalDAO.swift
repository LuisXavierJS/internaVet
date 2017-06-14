//
//  AnimalDAO.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class AnimalDAO: NSObject {
    
    fileprivate static func getAnimalFromCoreData(ofId: String)->Animal?{
        let predicate = NSPredicate(format: "idAnimal = %@", ofId)
        guard let animal = CoreDataManager.fetchRequest(Animal.self, predicate: predicate).first else {
            return nil
        }
        return animal
    }
    
    static func fetchAnimal(fromIdAnimal id: String)->Animal?{
        guard let animal = getAnimalFromCoreData(ofId: id) else {return nil}
        return animal
    }
    
    static func fetchAnimais(fromIdProprietario id: String) -> [Animal] {
        let predicate = NSPredicate(format: "idProprietario = %@", id)
        return CoreDataManager.fetchRequest(Animal.self, predicate: predicate)
    }
    
    static func deleteAnimal(animal: Animal){
        if let canil = animal.canil{
            CanilDAO.desocuparCanil(canil: canil)
        }
        CoreDataManager.deleteObjects(Animal.self, objects: [animal])
    }
    
    static func deleteAnimal(fromIdAnimal id: String){
        if let animal = fetchAnimal(fromIdAnimal: id){
            self.deleteAnimal(animal: animal)
        }
    }
    
    static func createAnimal()->Animal{
        let animal = CoreDataManager.createEntity(Animal.self)
        return animal
    }
    
    static func fetchAll()->[Animal]{
        return CoreDataManager.fetchRequest(Animal.self)
    }
    
}
