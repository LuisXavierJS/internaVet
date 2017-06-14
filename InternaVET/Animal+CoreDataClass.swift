//
//  Animal+CoreDataClass.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import Foundation
import CoreData


public class Animal: NSManagedObject, TableDataProtocol {
    var proprietario: Proprietario? {
        guard let idProprietario = self.idProprietario else { return nil }
        return ProprietarioDAO.fetchProprietario(fromIdProprietario: idProprietario)
    }        
    
    func tempoRestanteDeInternacao()->String?{
        guard let dataDeAlta = self.calcularDataDeAlta() else {return nil}
        if (dataDeAlta as Date) < Date() { return nil }
        let tempoAteAlta = dataDeAlta.timeIntervalSinceNow
        let diasDeAlta = tempoAteAlta/60/60/24
        let diasString: String = diasDeAlta < 1 ? "" : (diasDeAlta < 2 ? "1 dia e " : String(Int(diasDeAlta)) + " dias e")
        let horasDeAlta = tempoAteAlta.truncatingRemainder(dividingBy: 60 * 60 * 24)/60/60
        let horasString: String = (horasDeAlta < 2 ? (NSString(format:"%.1f",horasDeAlta) as String) + " hora" : String(Int(horasDeAlta)) + " horas")
        return diasString + horasString
    }
    
    func calcularDataDeAlta()->NSDate?{
        guard let dataCadastro = self.dataDoCadastro,
            let altaDoPacienteText = self.altaString?.components(separatedBy: ".").first,
            let tipoDeAlta = self.altaString?.components(separatedBy: ".").last,
            let altaDoPaciente = Double(altaDoPacienteText) else {
                return nil
        }
        let tipoTempoInternacao: Double = tipoDeAlta.localizedCaseInsensitiveContains("hora") ? 1 : 24
        let tempoInternacao = altaDoPaciente * tipoTempoInternacao * 60 * 60
        return dataCadastro.addingTimeInterval(tempoInternacao)
    }
    
    func tempoDeAltaText()->String?{
        return self.altaString?.components(separatedBy: ".").first
    }
    
    func tipoDeAlta()->String?{
        return self.altaString?.components(separatedBy: ".").last
    }
    
    func getTitle() -> String {
        return self.nomeAnimal ?? "--"
    }
    
    func getSubTitle() -> String {
        return self.raca ?? "--"
    }
}
