//
//  GerenciadorDeTarefasProtocol.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 10/06/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

@objc protocol GerenciadorDeTarefasProtocol: class{
    func disparouNotificacaoDaTarefa(tarefa: Tarefa)
    @objc optional func vaiAtualizarAsTarefas()
    @objc optional func atualizouAsTarefas(paraTarefas: [Tarefa])
}
