//
//  MainViewController.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 16/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit
import CoreData

class ListaTarefasVC: ListaBaseVC,MainTabBarControllerItemProtocol, CadastroControllerDelegate, ExpandCollapseProtocol, GerenciadorDeTarefasProtocol {

    lazy var dataSource: ExpandCollapseTableManager<Tarefa> = {
        return ExpandCollapseTableManager<Tarefa>(delegate: self as ExpandCollapseProtocol, tableView: self.tableView)
    }()
    
    lazy var gerenciadorDeTarefa: GerenciadorDeTarefas = {
        let gerenciador = GerenciadorDeTarefas.current
        gerenciador.delegate = self
        return gerenciador
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 380
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let newData = gerenciadorDeTarefa.listaOrdenadaDasTarefasPendentes()
        self.dataSource.refreshData(withData: newData)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    
    private func tarefaMainCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TarefaMainCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TarefaMainCell", for: indexPath) as! TarefaMainCell
        if let tarefa = self.dataSource.dataForIndex(indexPath: indexPath){
            let dataMap = self.dataSource.dataMapForIndexPath(indexPath: indexPath).id
            cell.setup(withTarefa: tarefa, ofOcorrencia: dataMap)
        }
        return cell
    }
    
    private func tarefaBodyCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TarefaBodyCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TarefaBodyCell", for: indexPath) as! TarefaBodyCell
        if let tarefa = self.dataSource.dataForIndex(indexPath: indexPath){
            cell.setup(withTarefa: tarefa)
        }
        return cell
    }

    func mainTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        return tarefaMainCell(tableView, cellForRowAt: indexPath)
    }
    
    func bodyTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        return tarefaBodyCell(tableView, cellForRowAt: indexPath)
    }
    
    func shouldExpandCollapse(_ tableView: UITableView, forRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func deleteAtIndex(index: IndexPath) {
        let action = UIAlertAction(title: "Sim", style: .destructive) { (_) in
            if let data = self.dataSource.dataForIndex(indexPath: index){
                CoreDataManager.deleteObjects(Tarefa.self, objects: [data])
                self.dataSource.refreshData()
            }
        }
        let not = UIAlertAction(title: "Não", style: .cancel, handler: nil)
        self.presentAlert(title: "Atenção", message: "Removendo esta tarefa, todos os horarios serão desmarcados", actions: [action,not])
    }
    
    func bodyCellSelected(at index: IndexPath){
        let data = self.dataSource.dataForIndex(indexPath: index)
        if let navController = CadastroMedicacaoVC.instantiateThisNavigationController(forStoryboard: "Cadastros"),
            let controller = navController.topViewController as? CadastroMedicacaoVC{
            controller.medicacao = data
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    }
    
    // MARK: - MainTabBarControllerItemProtocol
    
    func addButtonTapped(){
        self.presentCadastroControllerOfType(type: CadastroMedicacaoVC.self)
    }
    
    func disparouNotificacaoDaTarefa(tarefa: Tarefa) {
        if let navTopCtrlr = self.navigationController?.visibleViewController{
            let alert = UIAlertController(title: tarefa.tipoTarefa, message: tarefa.descricao(), preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            navTopCtrlr.present(alert, animated: true, completion: nil)
        }
    }
    
    func atualizouAsTarefas(paraTarefas: [Tarefa]) {
        self.dataSource.refreshData(withData: paraTarefas)
    }

}
