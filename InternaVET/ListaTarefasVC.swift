//
//  MainViewController.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 16/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ListaTarefasVC: ListaBaseVC,MainTabBarControllerItemProtocol, CadastroControllerDelegate, ExpandCollapseProtocol {
    func deleteAtIndex(index: IndexPath) {
        print("precisa deletar")
    }

    lazy var dataSource: ExpandCollapseTableManager<Tarefa> = {
        return ExpandCollapseTableManager<Tarefa>(delegate: self as ExpandCollapseProtocol, tableView: self.tableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataSource.refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }    
    
    private func tarefaMainCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TarefaMainCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TarefaMainCell", for: indexPath) as! TarefaMainCell
        cell.tag = indexPath.row
        return cell
    }
    
    private func tarefaBodyCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> TarefaBodyCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TarefaBodyCell", for: indexPath) as! TarefaBodyCell
        cell.tag = indexPath.row
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
    
    // MARK: - MainTabBarControllerItemProtocol
    
    func addButtonTapped(){
        self.presentCadastroControllerOfType(type: CadastroMedicacaoVC.self)
    }


}
