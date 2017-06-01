//
//  CanilDAO.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

enum EstadoCanil: String{
    case livre = "liberado"
    case ocupado = "ocupado"
}

class CanilDAO: NSObject {
    private static var canis: [String] = {
       return loadCanisFromFile()
    }()
    
    private class func getPathForJsonResource(resourceName name: String) -> String?{
        let bundle = Bundle(for: self)
        return bundle.path(forResource: name, ofType: "json")
    }
    
    private class func loadJSONFile(withName name: String) -> NSData? {
        var data: NSData? = nil
        if let filePath = getPathForJsonResource(resourceName: name),
        let loadedData = NSData(contentsOfFile: filePath) {
            data = loadedData
        }
        return data
    }
    
    private class func loadCanisFromFile()->[String]{
        do{
            if let data = self.loadJSONFile(withName: "canil"),
            let array = try JSONSerialization.jsonObject(with: Data(referencing: data), options: .allowFragments) as? [String]{
                return array
            }
        }catch let error as NSError{
            print("could not load canis -> \(error), \(error.userInfo)")
        }
        return []
    }
    
    private class func saveCanisToFile(){
        do{
            let data = try JSONSerialization.data(withJSONObject: self.canis, options: .prettyPrinted)
            let nsData = NSData(data: data)
            if let filePath = self.getPathForJsonResource(resourceName: "canil"){
                nsData.write(toFile: filePath, atomically: true)
            }
        }catch let error as NSError{
            print("could not save canis -> \(error), \(error.userInfo)")
        }
    }
    
    private class func estadoDoCanil(canil: String) -> String{
        return canil.components(separatedBy: ".").first!
    }
    
    private class func estadoDoCanil(index: Int) -> String{
        return self.canis[index].components(separatedBy: ".").first!
    }
    
    private class func indexDoCanil(canil: String) -> String{
        return canil.components(separatedBy: ".").last!
    }
    
    private class func indexDoCanil(index: Int) -> String{
        return self.canis[index].components(separatedBy: ".").last!
    }
    
    class func numeroDoCanil(canil: String) -> Int{
        return Int(self.indexDoCanil(canil: canil))! + 1
    }
    
    class func numeroDoCanil(_ index: Int) -> String{
        return String(Int(self.indexDoCanil(index: index))! + 1)
    }
    
    class func canilEstaLivre(canil: String) -> Bool{
        return self.estadoDoCanil(canil: canil) == EstadoCanil.livre.rawValue
    }
    
    class func canilEstaLivre(index: Int) -> Bool{
        return self.estadoDoCanil(index: index) == EstadoCanil.livre.rawValue
    }
    
    class func liberarCanilDeIndex(index: Int){
        self.canis[index] = EstadoCanil.livre.rawValue + ".\(index)"
        self.saveCanisToFile()
    }
    
    class func ocuparCanilDeIndex(index: Int){
        self.canis[index] = EstadoCanil.ocupado.rawValue + ".\(index)"
        self.saveCanisToFile()
    }
    
    class func canisLivres()->[String]{
        return self.canis.filter({self.canilEstaLivre(canil: $0)}).map({String(self.numeroDoCanil(canil:$0))})
    }
 
    class func canisOcupados()->[String]{
        return self.canis.filter({!self.canilEstaLivre(canil: $0)}).map({String(self.numeroDoCanil(canil:$0))})
    }
}
