//
//  NSDate+Helpers.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

extension NSDate {
    func hourString()->String{
        let dateFormat = DateFormatter()
        let dia: String = self.dayString()
        dateFormat.dateFormat = "HH:mm"
        return "\(dia), às " + dateFormat.string(from: self as Date)
    }
    
    func toString(withFormat: String = "dd/MM/yyyy HH:mm")->String{
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = withFormat
        return dateFormat.string(from: self as Date)
    }
    
    func dayString()->String{
        if self.dia == NSDate().dia {
            return "Hoje"
        }else if self.dia - 1 == NSDate().dia{
            return "Amanhã"
        }else if self.dia - 2 == NSDate().dia {
            return "Depois de amanhã"
        }else{
            return "No dia \(self.dia)"
        }
    }
    
    var dia: Int{
        return Calendar.current.component(.day, from: self as Date)
    }
    var mes: Int{
        return Calendar.current.component(.month, from: self as Date)
    }
    var ano: Int{
        return Calendar.current.component(.year, from: self as Date)
    }
    var hora: Int{
        return Calendar.current.component(.hour, from: self as Date)
    }
    var minuto: Int{
        return Calendar.current.component(.minute, from: self as Date)
    }
}


extension Date{
    var noSeconds: Date{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let dateNoSeconds = formatter.date(from: formatter.string(from: self))
        return dateNoSeconds ?? self
    }
}
