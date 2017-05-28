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
        let hora = self.getNSDateDaDoseMaisProxima()
        return hora.hourString()
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
        return self.inicioDaTarefa?.hourString()
    }
    func getFimDaTarefa()->String?{
        return self.fimDaTarefa?.hourString()
    }
    func getHoraDaDoseSequente()->String?{
        return self.getNSDateDaDoseSequente()?.hourString()
    }
    
    func getNSDateDaDoseSequente()->NSDate?{
        let interval = self.intervaloEntreExecucoes * 60 * 60
        let horaMaisProxima = getNSDateDaDoseMaisProxima() as Date
        let horaSequente = horaMaisProxima.addingTimeInterval(interval)
        let fimDaTarefa = self.fimDaTarefa as! Date
        let hora: Date? = horaSequente > fimDaTarefa ? nil : horaSequente
        return hora as NSDate?
    }
    
    func getNSDateDaDoseMaisProxima()->NSDate{
        let interval = self.intervaloEntreExecucoes * 60 * 60
        let dataAtual = Date()
        var dataVar = self.inicioDaTarefa as! Date
        while dataVar < dataAtual {//dataVar.compare(NSDate()) == ComparisonResult.orderedDescending{
           dataVar = dataVar.addingTimeInterval(interval)
        }
        return dataVar as NSDate
    }

}
