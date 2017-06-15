//
//  TarefaDAO.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class TarefaDAO: NSObject {
    fileprivate static func getTarefaFromCoreData(ofId: String)->Tarefa?{
        let predicate = NSPredicate(format: "idTarefa = %@", ofId)
        guard let tarefa = CoreDataManager.fetchRequest(Tarefa.self, predicate: predicate).first else {
            return nil
        }
        return tarefa
    }
    
    static func fetchTarefa(fromIdTarefa id: String)->Tarefa?{
        return getTarefaFromCoreData(ofId: id)
    }
    
    static func deleteTarefa(tarefa: Tarefa){
        GerenciadorDeTarefas.deleteNotification(forTarefa: tarefa)
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
