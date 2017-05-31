//
//  ExpandCollapseTableDataSource.swift
//  InternaVET
//
//  Created by Luiz Cesar Lopes on 28/05/17.
//  Copyright © 2017 Jorge Luis. All rights reserved.
//

import UIKit
import CoreData

fileprivate enum State: Int{
    case Collapse = -1
    case Expand = 1
}

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
        tableView.clipsToBounds = true
    }
    
    func refreshData(){
        self.bodyCellsIndexPath = []
        self.dataSource = CoreDataManager.fetchRequest(T.self)
        self.tableView.reloadData()
    }
    
    func dataForIndex(indexPath: IndexPath) -> T? {
        var index = indexPath
        if self.bodyCellsIndexPath.contains(indexPath){
            index = IndexPath(row:index.row - 1, section: index.section)
        }
        if index.row >= self.dataSource.count {
            return nil
        }
        return self.dataSource[index.row]
    }
    
    func expandAtIndex(indexPath: IndexPath){
        let bodyIndex = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        self.refreshBodyCellsIndexPathForState(state: .Expand, atIndex: indexPath)
        self.bodyCellsIndexPath.append(bodyIndex)
        self.tableView.insertRows(at: [bodyIndex], with: .top)
    }
    
    func collapseAtIndex(indexPath: IndexPath){
        let bodyIndex = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        self.bodyCellsIndexPath.remove(at: self.bodyCellsIndexPath.index(of: bodyIndex)!)
        self.refreshBodyCellsIndexPathForState(state: .Collapse, atIndex: indexPath)
        self.tableView.deleteRows(at: [bodyIndex], with: .top)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
                self.collapseAtIndex(indexPath: indexPath)
            }else{
                self.expandAtIndex(indexPath: indexPath)
            }
            print("did expand collapse")
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
    
    private func refreshBodyCellsIndexPathForState(state:State, atIndex: IndexPath){
        var newBodyCellsIndex: [IndexPath] = []
        for index in bodyCellsIndexPath{
            if index.row > atIndex.row{
               newBodyCellsIndex.append(IndexPath(row: index.row + state.rawValue, section: index.section))
            }else{
                newBodyCellsIndex.append(index)
            }
        }
        self.bodyCellsIndexPath = newBodyCellsIndex
    }
}
