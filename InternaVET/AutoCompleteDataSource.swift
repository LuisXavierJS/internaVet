//
//  AutoCompleteDataSource.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 04/06/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit
enum TipoDeCompletador: String{
    case CanisFamiliaris = "Canis familiaris"
    case FelisCatus = "Felis catus"
    case Exame = "Exame"
    case Procedimento = "Procedimento"
    case Medicamento = "Medicamento"
}
class AutoCompleteDataSource: NSObject {
    var tipoDeCompletador: TipoDeCompletador
    
    init(tipoDeAutoComplete:TipoDeCompletador){
        self.tipoDeCompletador = tipoDeAutoComplete
    }
    
    func stringsQueCompletam(string: String) -> [String]?{
        var tipoDeAutocomplete = self.tipoDeCompletador.rawValue
        if let firstChar = string.uppercased().first{
            tipoDeAutocomplete.insert(firstChar, at: tipoDeAutocomplete.startIndex)
            let bundle = Bundle(for: AutoCompleteDataSource.self)
            if let filePath = bundle.path(forResource: tipoDeAutocomplete, ofType: "txt"){
                do{
                    let autoCompleteData = try String(contentsOfFile: filePath)
                    return autoCompleteData.components(separatedBy: ".")
                        .filter({!$0.isEmpty && $0.localizedCaseInsensitiveContains(string)})
                }catch let error as NSError {
                    print("could not get autocomplete of \(tipoDeAutocomplete) for string \(string) because of error: \(error)")
                }
            }
        }
        return nil
    }
    
    class func inserirStringCasoNaoExista(string:String, paraCompletar: TipoDeCompletador){
        var tipoDeAutocomplete = paraCompletar.rawValue
        if let firstChar = string.uppercased().first{
            tipoDeAutocomplete.insert(firstChar, at: tipoDeAutocomplete.startIndex)
            let bundle = Bundle(for: AutoCompleteDataSource.self)
            if let filePath = bundle.path(forResource: tipoDeAutocomplete, ofType: "txt"){
                do{
                    let autoCompleteData = try String(contentsOfFile: filePath)
                    if !autoCompleteData.components(separatedBy: ".").contains(where: {$0.uppercased() == string.uppercased()}){
                        let autoCompleteUpdatedData = autoCompleteData + string + "."
                        try autoCompleteUpdatedData.write(toFile: filePath, atomically: true, encoding: .utf8)
                    }
                }catch let error as NSError {
                    print("could not update autocomplete of \(tipoDeAutocomplete) for string \(string) because of error: \(error)")
                }
            }
        }
    }
}
