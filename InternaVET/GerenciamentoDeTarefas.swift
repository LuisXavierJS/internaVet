//
//  HorarioDaTarefaBusiness.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit
import UserNotifications
//Classe responsavel por lidar com o gerenciamento dos horarios e disparo de alarmes das tarefas cadastradas!
class GerenciadorDeTarefas: NSObject, UNUserNotificationCenterDelegate {
    static let current: GerenciadorDeTarefas = GerenciadorDeTarefas()
    
    weak var delegate: GerenciadorDeTarefasProtocol? = nil

    static func putNotification(forTarefa tarefa: Tarefa){
        guard let tipoTarefa = tarefa.tipoTarefa, let idTarefa = tarefa.idTarefa else{return}
        let dataTarefa = tarefa.getNSDateDaDoseMaisProxima() as Date
        let components = Calendar.current.dateComponents([.day,.hour,.minute], from: dataTarefa)
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let notificationContent = UNMutableNotificationContent()
        notificationContent.sound = UNNotificationSound.init(named: "alarme.caf")
        notificationContent.title = "\(tipoTarefa)!"
        notificationContent.body = tarefa.descricao()
        let request = UNNotificationRequest(identifier: idTarefa, content: notificationContent, trigger: notificationTrigger)        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [idTarefa])
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error{
                print("Erro ao adicionar notificação: \(error.localizedDescription)")
            }
        }
    }
    
    
    static func reloadAllNotifications(){
        GerenciadorDeTarefas.current.delegate?.vaiAtualizarAsTarefas?()
        let tarefas = GerenciadorDeTarefas.current.listaOrdenadaDasTarefasPendentes()
        for tarefa in tarefas{
            putNotification(forTarefa: tarefa)
        }
        GerenciadorDeTarefas.current.delegate?.atualizouAsTarefas?(paraTarefas: tarefas)
    }
    
    override init(){
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
}

extension GerenciadorDeTarefas{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive:response.actionIdentifier: " + response.actionIdentifier)
        print("didReceive:response.notification.request.requestIdentifier: " + response.notification.request.identifier)
        self.atualizarTarefa(deId: response.notification.request.identifier)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent:notification.request.requestIdentifier: " + notification.request.identifier)
        self.atualizarTarefa(deId: notification.request.identifier)
    }
    
    func atualizarTarefa(deId id: String){
        self.delegate?.vaiAtualizarAsTarefas?()
        if let tarefa = TarefaDAO.fetchTarefa(fromIdTarefa: id){
            if ((tarefa.getNSDateDaDoseMaisProxima() as Date) > Date()) {
                GerenciadorDeTarefas.putNotification(forTarefa: tarefa)
            }
        }
        self.delegate?.atualizouAsTarefas?(paraTarefas: self.listaOrdenadaDasTarefasPendentes())
    }
    
    func listaOrdenadaDeTodasAsTarefas()->[Tarefa]{
        UNUserNotificationCenter.current().delegate = self
        return TarefaDAO.fetchAll().sorted(by: { (tarefa1, tarefa2) -> Bool in
            return ((tarefa1.getNSDateDaDoseMaisProxima() as Date) < (tarefa2.getNSDateDaDoseMaisProxima() as Date))
        })
    }
    
    func listaOrdenadaDasTarefasPendentes()->[Tarefa]{
        UNUserNotificationCenter.current().delegate = self
        return listaOrdenadaDeTodasAsTarefas().filter({ (tarefa) -> Bool in
            let estaPendente = ((tarefa.getNSDateDaDoseMaisProxima() as Date) > Date())
            if !estaPendente{
                TarefaDAO.deleteTarefa(tarefa: tarefa)
            }
            return estaPendente
        })
    }
    
    

}
