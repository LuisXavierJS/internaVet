//
//  ListaProprietariosVC.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 16/02/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit

class ListaProprietariosVC: ListaBaseVC,MainTabBarControllerItemProtocol, CadastroControllerDelegate, ExpandCollapseProtocol {
    
    lazy var dataSource: ExpandCollapseTableManager<Proprietario> = {
        return ExpandCollapseTableManager<Proprietario>(delegate: self as ExpandCollapseProtocol, tableView: self.tableView)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataSource.refreshData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mainTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProprietarioMainCell", for: indexPath) as! ProprietarioMainCell
        if let proprietario = self.dataSource.dataForIndex(indexPath: indexPath){
            cell.setup(withProprietario: proprietario)
        }
        return cell
    }
    
    func bodyTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProprietarioBodyCell", for: indexPath) as! ProprietarioBodyCell
        if let proprietario = self.dataSource.dataForIndex(indexPath: indexPath){
            cell.setup(withProprietario: proprietario)
        }
        return cell
    }
    
    func shouldExpandCollapse(_ tableView: UITableView, forRowAt indexPath: IndexPath)->Bool{
        return true
    }
    
    func deleteAtIndex(index: IndexPath) {
        if let data = self.dataSource.dataForIndex(indexPath: index){
            ProprietarioDAO.deleteProprietario(proprietario: data)
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .normal, title: "Editar") { (action, index) in
            let data = self.dataSource.dataForIndex(indexPath: index)
            if let navController = CadastroProprietarioVC.instantiateThisNavigationController(forStoryboard: "Cadastros"),
                let controller = navController.topViewController as? CadastroProprietarioVC{
                controller.proprietario = data
                self.navigationController?.present(navController, animated: true, completion: nil)
            }
        }
        return [action]
    }
    
    // MARK: - Table view data source
    func addButtonTapped(){
        self.presentCadastroControllerOfType(type: CadastroProprietarioVC.self)
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
