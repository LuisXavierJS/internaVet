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
    lazy var proprietario: Proprietario? = {
        return ProprietarioDAO.fetchProprietario(fromIdProprietario: self.idProprietario!)
    }()
    
    var canilInt: Int{
        return Int(self.canil)
    }
    
    var canilStr: String{
        return String(canilInt)
    }
    
     func calcularTempoDeAlta()->NSDate?{
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
