//
//  TarefaDAO.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class TarefaDAO: NSObject {
    fileprivate static var cacheDeTarefas: [Tarefa] = []
    
    fileprivate static func addToCache(tarefa: Tarefa){
        if !self.cacheDeTarefas.contains(where: {$0.idTarefa == tarefa.idTarefa}){
            self.cacheDeTarefas.append(tarefa)
        }
    }
    
    fileprivate static func getTarefaFromCache(ofId: String)->Tarefa?{
        return self.cacheDeTarefas.first(where: {$0.idTarefa == ofId})
    }
    
    fileprivate static func getTarefaFromCoreData(ofId: String)->Tarefa?{
        let predicate = NSPredicate(format: "idTarefa = %@", ofId)
        guard let tarefa = CoreDataManager.fetchRequest(Tarefa.self, predicate: predicate).first else {
            return nil
        }
        self.addToCache(tarefa: tarefa)
        return tarefa
    }
    
    static func fetchTarefa(fromIdTarefa id: String)->Tarefa?{
        if let tarefa = getTarefaFromCache(ofId: id) {
            return tarefa
        }
        return getTarefaFromCoreData(ofId: id)
    }
    
    static func deleteTarefa(tarefa: Tarefa){
        CoreDataManager.deleteObjects(Tarefa.self, objects: [tarefa])
    }
    
    static func deleteTarefa(fromIdTarefa id: String){
        if let tarefa = fetchTarefa(fromIdTarefa: id){
            self.deleteTarefa(tarefa: tarefa)
        }
    }
    
    static func fetchAll()->[Tarefa]{
        return CoreDataManager.fetchRequest(Tarefa.self)
    }
    
    static func createTarefa()->Tarefa{
        let tarefa = CoreDataManager.createEntity(Tarefa.self)
        return tarefa
    }
}
