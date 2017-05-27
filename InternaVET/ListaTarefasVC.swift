//
//  MainViewController.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 16/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ListaTarefasVC: ListaBaseVC,MainTabBarControllerItemProtocol, CadastroControllerDelegate {
    var dataSource:[TarefaDataProtocol] = []
    var bodyCellsIndexPath: [IndexPath] = [IndexPath(row:0,section:0)]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count + self.bodyCellsIndexPath.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.bodyCellsIndexPath.contains(indexPath) {
            return self.tarefaBodyCell(tableView,cellForRowAt: indexPath)
        }else{
            return self.tarefaMainCell(tableView,cellForRowAt: indexPath)
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    // MARK: - MainTabBarControllerItemProtocol
    
    func addButtonTapped(){
        self.presentCadastroControllerOfType(type: CadastroMedicacaoVC.self)
    }


}
