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
    
    fileprivate static func removeFromCache(animal: Animal){
        if let index = self.cacheDeAnimais.index(of: animal){
            self.cacheDeAnimais.remove(at: index)
        }
    }
    
    fileprivate static func getAnimalFromCache(ofId: String)->Animal?{
        return self.cacheDeAnimais.first(where: {$0.idAnimal == ofId})
    }
    
    fileprivate static func getAnimaisFromCache(ofIdProprietario id: String) -> [Animal] {
        return self.cacheDeAnimais.filter({$0.idProprietario == id})
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
        guard let animal = getAnimalFromCoreData(ofId: id) else {return nil}
        self.addToCache(animal: animal)
        return animal
    }
    
    static func fetchAnimais(fromIdProprietario id: String) -> [Animal] {
        let animaisFromCache = self.fetchAnimais(fromIdProprietario: id)
        if !animaisFromCache.isEmpty{
            return animaisFromCache
        }
        let predicate = NSPredicate(format: "idProprietario = %@", id)
        return CoreDataManager.fetchRequest(Animal.self, predicate: predicate)
    }
    
    static func deleteAnimal(animal: Animal){
        CanilDAO.liberarCanilDeIndex(index: animal.canilInt)
        self.removeFromCache(animal: animal)
        CoreDataManager.deleteObjects(Animal.self, objects: [animal])
    }
    
    static func deleteAnimal(fromIdAnimal id: String){
        if let animal = fetchAnimal(fromIdAnimal: id){
            self.deleteAnimal(animal: animal)
        }
    }
    
    static func createAnimal()->Animal{
        let animal = CoreDataManager.createEntity(Animal.self)
        self.addToCache(animal: animal)
        return animal
    }
    
    static func reloadAll(){
        self.cacheDeAnimais = fetchAll()
    }
    
    static func fetchAll()->[Animal]{
        return CoreDataManager.fetchRequest(Animal.self)
    }
    
}
