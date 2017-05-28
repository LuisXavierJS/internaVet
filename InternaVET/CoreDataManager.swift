//
//  CoreDataManager.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit
import CoreData

extension AppDelegate{
    fileprivate static func persistenceViewContext() -> NSManagedObjectContext{
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                fatalError("O shared delegate da aplicaçao nao foi reconhecido como AppDelegate!")
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        return managedContext
    }
}

class CoreDataManager: NSObject{
    static var context:NSManagedObjectContext = {
        return AppDelegate.persistenceViewContext()
    }()
    
    static func fetchRequest<T:NSManagedObject>(_ type: T.Type, predicate: NSPredicate? = nil)->[T]{
        let entityName = T.className()
        let fetchRequest = NSFetchRequest<T>(entityName:entityName)
        fetchRequest.predicate = predicate
        do{
            return try context.fetch(fetchRequest)
        }catch let error as NSError{
            print("could not fetch entity \(entityName) -> \(error), \(error.userInfo)")
        }
        return []
    }
    
    static func createEntity<T:NSManagedObject>(_ type: T.Type)->T{
        let entityName = T.className()
        let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! T
        self.saveContext("creating an entity for \(entityName)")
        return entity
    }
    
    static func deleteObjects<T:NSManagedObject>(_ type: T.Type, objects: [T]){
        for obj in objects{
            context.delete(obj)
        }
        self.saveContext("deleting \(objects.count) objects of type \(T.className())")
    }
    
    static func saveContext(_ contextMessage: String){
        do{
            try context.save()
        }catch let error as NSError{
            print("could not save the context \"\(contextMessage)\" -> \(error), \(error.userInfo)")
        }
    }
}

