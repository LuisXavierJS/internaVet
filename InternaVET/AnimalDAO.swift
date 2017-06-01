//
//  AnimalDAO.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class AnimalDAO: NSObject {
    fileprivate static var cacheDeAnimais: [Animal] = []
    
    fileprivate static func addToCache(animal: Animal){
        if !self.cacheDeAnimais.contains(where: {$0.idAnimal == animal.idAnimal}){
            self.cacheDeAnimais.append(animal)
        }
    }
    
    fileprivate static func getAnimalFromCache(ofId: String)->Animal?{
        return self.cacheDeAnimais.first(where: {$0.idAnimal == ofId})
    }
    
    fileprivate static func getAnimalFromCoreData(ofId: String)->Animal?{
        let predicate = NSPredicate(format: "idAnimal = %@", ofId)
        guard let animal = CoreDataManager.fetchRequest(Animal.self, predicate: predicate).first else {
            return nil
        }
        self.addToCache(animal: animal)
        return animal
    }
    
    static func fetchAnimal(fromIdAnimal id: String)->Animal?{
        if let animal = getAnimalFromCache(ofId: id) {
            return animal
        }
        return getAnimalFromCoreData(ofId: id)
    }
    
    static func deleteAnimal(animal: Animal){
        CanilDAO.liberarCanilDeIndex(index: animal.canilInt)
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
    
    static func reloadAll(){
        self.cacheDeAnimais = fetchAll()
    }
    
    static func fetchAll()->[Animal]{
        return CoreDataManager.fetchRequest(Animal.self)
    }
    
}
