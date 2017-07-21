//
//  Tarefa+CoreDataClass.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import CoreData


extension Tarefa {
    
    func getNomeDoAnimal()->String?{
        return animal?.nomeAnimal
    }
    func getRacaDoAnimal()->String?{
        return animal?.raca
    }
    func getHoraDaTarefa()->String?{
        let hora = self.getNSDateDaDoseMaisProxima()
        if (hora as Date).noSeconds == Date().noSeconds {
            return "Agora!"
        }
        return hora.hourString()
    }
    func getDadosDoProprietario()->String?{
        return self.animal?.proprietario?.getDados()
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
    func intervaloEntreAplicacoes()->String{
        let intervalo = Int(self.intervaloEntreExecucoes)
        if intervalo == 0 {
            return "Aplicação única"
        }else if intervalo == 1{
            return String(intervalo) + " hora"
        }else{
            return String(intervalo)  + " horas"
        }
    }
    
    func getNumeroTotalDeAplicacoes()->Int{
        if self.intervaloEntreExecucoes == 0 { return 1 }
        var numero: Int = 0
        let interval = self.intervaloEntreExecucoes * 60 * 60
        let dataFim = (self.fimDaTarefa! as Date).noSeconds
        var dataVar = (self.inicioDaTarefa! as Date).noSeconds
        while dataVar < dataFim {//dataVar.compare(NSDate()) == ComparisonResult.orderedDescending{
            dataVar = dataVar.addingTimeInterval(interval)
            numero+=1
        }
        return numero
    }
    
    func getAplicacoesRestantes()->[Int]{
        if self.intervaloEntreExecucoes == 0 { return [0] }
        var numero: Int = 0
        var aplicacoes: [Int] = []
        let interval = self.intervaloEntreExecucoes * 60 * 60
        let dataAtual = (NSDate() as Date).noSeconds
        let dataFim = (self.fimDaTarefa! as Date).noSeconds
        var dataVar = (self.inicioDaTarefa! as Date).noSeconds
        while dataVar < dataFim {//dataVar.compare(NSDate()) == ComparisonResult.orderedDescending{
            if dataVar > dataAtual{
                aplicacoes.append(numero)
            }
            dataVar = dataVar.addingTimeInterval(interval)
            numero+=1
        }
        return aplicacoes
    }
    
    func getDataDaAplicacaoDeNumero(numeroDaAplicacao numero: Int) -> Date?{
        return nil
    }
    
    func getNSDateDaDoseSequente()->NSDate?{
        if self.intervaloEntreExecucoes == 0 { return nil }
        let interval = self.intervaloEntreExecucoes * 60 * 60
        let horaMaisProxima = (getNSDateDaDoseMaisProxima() as Date).noSeconds
        let horaSequente = (horaMaisProxima.addingTimeInterval(interval)).noSeconds
        let fimDaTarefa = (self.fimDaTarefa! as Date).noSeconds
        let hora: Date? = horaSequente > fimDaTarefa ? nil : horaSequente
        return hora as NSDate?
    }
    
    func getNSDateDaDoseMaisProxima()->NSDate{
        if self.intervaloEntreExecucoes == 0 { return self.inicioDaTarefa! }
        let interval = self.intervaloEntreExecucoes * 60 * 60
        let dataAtual = (NSDate() as Date).noSeconds
        let dataFim = (self.fimDaTarefa! as Date).noSeconds
        var dataVar = (self.inicioDaTarefa! as Date).noSeconds
        while dataVar <= dataAtual && dataVar < dataFim {//dataVar.compare(NSDate()) == ComparisonResult.orderedDescending{
           dataVar = dataVar.addingTimeInterval(interval)
        }
        return dataVar as NSDate
    }
    
    func descricao()->String{
        guard let nomeTarefa = self.nomeTarefa,
            let nomePaciente = self.animal?.nomeAnimal else {
            return "Não há descrição para esta tarefa!"
        }
        var doseDescription: String = ""
        if  tipoTarefa == "Medicamento",
            let quantidadeDose = self.quantidadeDoseTarefa,
            let tipoDose = self.tipoDoseTarefa{
            doseDescription = quantidadeDose+tipoDose
            return "O paciente \(nomePaciente) deve ser tratado com o medicamento \(nomeTarefa) \(doseDescription)"
        }else{
            return "O \(tipoTarefa!) \(nomeTarefa) deve ser aplicado no paciente \(nomePaciente)"
        }
    }

}
