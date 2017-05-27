//
//  TarefaDataProtocol.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 27/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@objc protocol TarefaDataProtocol: class {
    func getNomeDoAnimal()->String?
    func getRacaDoAnimal()->String?
    func getNomeDaTarefa()->String?
    func getHoraDaTarefa()->String?
    func getTipoDaTarefa()->String?
    func getObservacoesDaTarefa()->String?
    @objc optional func getDadosDoProprietario()->String?
    @objc optional func getInicioDaTarefa()->String?
    @objc optional func getFimDaTarefa()->String?
    @objc optional func getHoraDaProximaDose()->String?
}
