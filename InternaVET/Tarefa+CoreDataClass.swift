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
    lazy weak var animal: Animal? = {
        return AnimalDAO.fetchAnimal(fromIdAnimal: self.idAnimal!)
    }()
    
    func getNomeDoAnimal()->String?{
        return animal?.nomeAnimal
    }
    func getRacaDoAnimal()->String?{
        return animal?.raca
    }
    func getNomeDaTarefa()->String?{
        return self.nomeTarefa
    }
    func getHoraDaTarefa()->String?{
        let hora = self.getHoraDaDoseMaisProxima()
        let dateFormatter = 
        return self.horaDaDoseMaisProxima
    }
    func getTipoDaTarefa()->String?{
        return self.tipoTarefa
    }
    func getObservacoesDaTarefa()->String?{
        return self.observacoesTarefa
    }
    func getDadosDoProprietario()->String?{
        return nil
    }
    func getInicioDaTarefa()->String?{
        return nil
    }
    func getFimDaTarefa()->String?{
        return nil
    }
    func getHoraDaDoseSequente()->String?{
        return nil
    }
    
    func getHoraDaDoseMaisProxima()->NSDate{
        //pegar o data de inicio e criar uma dataVar com ela
        //enquanto a dataVar for inferior a dataAtual
        //acrescentar intervalo na dataVar
        //
        return NSDate()
    }

}
