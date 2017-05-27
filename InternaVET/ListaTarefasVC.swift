//
//  MainViewController.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 16/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ListaTarefasVC: ListaBaseVC,MainTabBarControllerItemProtocol, CadastroControllerDelegate {
    var dataSource:[(rowDesc:String,rowDate:String)] = [(rowDesc:" XUBI RARI BRON ",rowDate:"??:??"),(rowDesc:" CHIN FURIN FULA ",rowDate:"!!:!!"),(rowDesc:" MEAMEN TONIN PHUS ",rowDate:"##:##"),(rowDesc:" DAFOQ ",rowDate:"--:--"),(rowDesc:" XUBI RARI BRON ",rowDate:"??:??"),(rowDesc:" CHIN FURIN FULA ",rowDate:"!!:!!"),(rowDesc:" MEAMEN TONIN PHUS ",rowDate:"##:##"),(rowDesc:" DAFOQ ",rowDate:"--:--"),(rowDesc:" XUBI RARI BRON ",rowDate:"??:??"),(rowDesc:" CHIN FURIN FULA ",rowDate:"!!:!!"),(rowDesc:" MEAMEN TONIN PHUS ",rowDate:"##:##"),(rowDesc:" DAFOQ ",rowDate:"--:--")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TarefaMainCell", for: indexPath) as? TarefaMainCell{
            cell.nomeTarefaLabel.text = self.dataSource[indexPath.row].rowDesc
            cell.horarioLabel.text = self.dataSource[indexPath.row].rowDate
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oldData = self.dataSource[indexPath.row]
        let newData = (rowDesc:oldData.rowDesc + oldData.rowDesc,rowDate:oldData.rowDate)
        self.dataSource[indexPath.row] = newData
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
//        self.tableView.layout(animated: true)
    }

    // MARK: - MainTabBarControllerItemProtocol
    
    func addButtonTapped(){
        self.presentCadastroControllerOfType(type: CadastroMedicacaoVC.self)
    }


}
