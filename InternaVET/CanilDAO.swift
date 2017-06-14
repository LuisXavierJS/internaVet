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
    private static var canis: [String: Bool] = {
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
    
    private class func loadCanisFromFile()->[String:Bool]{
        do{
            if let data = self.loadJSONFile(withName: "canil"),
            let dictionary = try JSONSerialization.jsonObject(with: Data(referencing: data), options: .allowFragments) as? [String:Bool]{
                return dictionary
            }
        }catch let error as NSError{
            print("could not load canis -> \(error), \(error.userInfo)")
        }
        return [:]
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
    
    class func ocuparCanil(canil: String){
        if let _ = self.canis[canil]{
            self.canis[canil] = true
            self.saveCanisToFile()
        }
    }
    
    class func desocuparCanil(canil: String){
        if let _ = self.canis[canil]{
            self.canis[canil] = false
            self.saveCanisToFile()
        }
    }
    
    class func canisDesocupados()->[String]{
        return self.canis.keys.filter({ (canil) -> Bool in
            return !self.canis[canil]! && Int(canil) != nil
        }).sorted(by: { (canil1, canil2) -> Bool in
            return Int(canil1)! < Int(canil2)!
        })
    }
    
}
