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
            cell.setup(withTarefa: tarefa)
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
        if let data = self.dataSource.dataForIndex(indexPath: index){
            TarefaDAO.deleteTarefa(tarefa: data)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .normal, title: "Editar") { (action, index) in
            let data = self.dataSource.dataForIndex(indexPath: index)
            if let navController = CadastroMedicacaoVC.instantiateThisNavigationController(forStoryboard: "Cadastros"),
                let controller = navController.topViewController as? CadastroMedicacaoVC{
                controller.medicacao = data
                self.navigationController?.present(navController, animated: true, completion: nil)
            }
        }
        return [action]
    }
    
    // MARK: - MainTabBarControllerItemProtocol
    
    func addButtonTapped(){
        self.presentCadastroControllerOfType(type: CadastroMedicacaoVC.self)
    }
    
    
    func atualizouAsTarefas(paraTarefas: [Tarefa]) {
        self.dataSource.refreshData(withData: paraTarefas)
    }

}
