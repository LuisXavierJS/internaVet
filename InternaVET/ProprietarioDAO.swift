//
//  ProprietarioDAO.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ProprietarioDAO: NSObject {
    
    fileprivate static func getProprietarioFromCoreData(ofId: String)->Proprietario?{
        let predicate = NSPredicate(format: "idProprietario = %@", ofId)
        guard let proprietario = CoreDataManager.fetchRequest(Proprietario.self, predicate: predicate).first else {
            return nil
        }
        return proprietario
    }
    
    static func fetchProprietario(fromIdProprietario id: String)->Proprietario?{
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
