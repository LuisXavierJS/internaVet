//
//  ProprietarioDAO.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ProprietarioDAO: NSObject {
    fileprivate static var cacheDeProprietarios: [Proprietario] = []
    
    fileprivate static func addToCache(proprietario: Proprietario){
        if !self.cacheDeProprietarios.contains(where: {$0.idProprietario == proprietario.idProprietario}){
            self.cacheDeProprietarios.append(proprietario)
        }
    }
    
    fileprivate static func getProprietarioFromCache(ofId: String)->Proprietario?{
        return self.cacheDeProprietarios.first(where: {$0.idProprietario == ofId})
    }
    
    fileprivate static func getProprietarioFromCoreData(ofId: String)->Proprietario?{
        let predicate = NSPredicate(format: "idProprietario = %@", ofId)
        guard let proprietario = CoreDataManager.fetchRequest(Proprietario.self, predicate: predicate).first else {
            return nil
        }
        self.addToCache(proprietario: proprietario)
        return proprietario
    }
    
    static func fetchProprietario(fromIdProprietario id: String)->Proprietario?{
        if let proprietario = getProprietarioFromCache(ofId: id) {
            return proprietario
        }
        return getProprietarioFromCoreData(ofId: id)
    }
    
    static func deleteProprietario(proprietario: Proprietario){
        CoreDataManager.deleteObjects(Proprietario.self, objects: [proprietario])
    }
    
    static func deleteProprietario(fromIdProprietario id: String){
        if let proprietario = fetchProprietario(fromIdProprietario: id){
            self.deleteProprietario(proprietario: proprietario)
        }
    }
    
    static func fetchAll()->[Proprietario]{
        return CoreDataManager.fetchRequest(Proprietario.self)
    }
    
    static func createProprietario()->Proprietario{
        let proprietario = CoreDataManager.createEntity(Proprietario.self)
        return proprietario
    }

}
