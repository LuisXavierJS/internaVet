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
    var horarios: [NSDate] {
        get{
            return self.horariosDasTarefas as? [NSDate] ?? []
        }
        set{
            self.horariosDasTarefas = newValue as NSArray
        }
    }
    
    func getNomeDoAnimal()->String?{
        return self.animal?.nomeAnimal
    }
    func getRacaDoAnimal()->String?{
        return self.animal?.raca
    }
    func getHoraDaTarefa(paraOcorrencia: Int)->String?{
        guard let hora = self.getDataDaAplicacaoDeNumero(numeroDaAplicacao: paraOcorrencia) as NSDate? else { return nil }
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
    
    func getNSDateDaDoseMaisProxima() -> NSDate {
        return self.horarios.first ?? self.inicioDaTarefa!
    }
    
    func getDataDaAplicacaoDeNumero(numeroDaAplicacao numero: Int) -> Date?{
        if numero >= 0 && numero < self.horarios.count{
            return self.horarios[numero] as Date
        }
        return nil
    }
    
    
    func getListaDeDosesPendentes()-> [NSDate]{
        if self.intervaloEntreExecucoes == 0 { return [self.inicioDaTarefa!] }
        var doses: [NSDate] = []
        let interval = self.intervaloEntreExecucoes * 60 * 60
        let dataAtual = (NSDate() as Date).noSeconds
        let dataFim = (self.fimDaTarefa! as Date).noSeconds
        var dataVar = (self.inicioDaTarefa! as Date).noSeconds
        while dataVar <= dataFim {//dataVar.compare(NSDate()) == ComparisonResult.orderedDescending{
            if dataVar >= dataAtual{
                doses.append(dataVar as NSDate)
            }
            dataVar = dataVar.addingTimeInterval(interval)
        }
        return doses
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
