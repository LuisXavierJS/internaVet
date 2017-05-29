//
//  ExpandCollapseTableDataSource.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit
import CoreData

protocol ExpandCollapseProtocol: UITableViewDelegate{
    func mainTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell
    func bodyTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell
    func shouldExpandCollapse(_ tableView: UITableView, forRowAt indexPath: IndexPath)->Bool
}

class ExpandCollapseTableManager<T:NSManagedObject>: NSObject, UITableViewDataSource, UITableViewDelegate{
    var dataSource:[T] = []
    var bodyCellsIndexPath: [IndexPath] = []
    weak var tableView: UITableView!
    weak var delegate: ExpandCollapseProtocol!
    
    init(delegate: ExpandCollapseProtocol, tableView: UITableView){
        self.delegate = delegate
        self.tableView = tableView
        super.init()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
    
    func refreshData(){
        self.bodyCellsIndexPath = []
        self.dataSource = CoreDataManager.fetchRequest(T.self)
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count + self.bodyCellsIndexPath.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.bodyCellsIndexPath.contains(indexPath) {
            return self.delegate.bodyTableViewCell(tableView, cellForRowAt: indexPath)
        }else{
            return self.delegate.mainTableViewCell(tableView, cellForRowAt: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.bodyCellsIndexPath.contains(indexPath) &&
        self.delegate.shouldExpandCollapse(tableView, forRowAt: indexPath){
            let bodyIndex = IndexPath(row: indexPath.row + 1, section: indexPath.section)
            if self.bodyCellsIndexPath.contains(bodyIndex){
                self.bodyCellsIndexPath.remove(at: self.bodyCellsIndexPath.index(of: bodyIndex)!)
                self.tableView.deleteRows(at: [bodyIndex], with: .top)
            }else{
                self.bodyCellsIndexPath.append(bodyIndex)
                self.tableView.insertRows(at: [bodyIndex], with: .bottom)
            }
        }
        self.delegate.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !self.bodyCellsIndexPath.contains(indexPath)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = self.delegate.tableView?(tableView, editActionsForRowAt: indexPath)
        let act = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            print("delete for index: \(index)")
        }
        actions?.append(act)
        return actions ?? [act]
    }
}
