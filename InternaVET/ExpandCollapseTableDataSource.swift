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
    case Remove = -2
    case Collapse = -1
    case Expand = 1
}

protocol ExpandCollapseProtocol: UITableViewDelegate{
    func mainTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell
    func bodyTableViewCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)->UITableViewCell
    func shouldExpandCollapse(_ tableView: UITableView, forRowAt indexPath: IndexPath)->Bool
    func deleteAtIndex(index: IndexPath)
}

class ExpandCollapseTableManager<T:NSManagedObject>: NSObject, UITableViewDataSource, UITableViewDelegate{
    var dataSource:[T] = []
    var bodyCellsIndexPath: [IndexPath] = []
    var numberOfCells: Int {
        return self.dataSource.count + self.bodyCellsIndexPath.count + 1
    }
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
    
    func refreshData(withData: [T]? = nil){
        self.bodyCellsIndexPath = []
        self.dataSource = withData ?? CoreDataManager.fetchRequest(T.self)
        self.tableView.reloadData()
    }
    
    func indexOfDataFor(indexPath: IndexPath) -> Int{
        var index = indexPath
        if self.bodyCellsIndexPath.contains(indexPath){
            index = IndexPath(row:index.row - 1, section: index.section)
        }
        var dataIndex: Int = 0
        let numberOfRows = self.dataSource.count + self.bodyCellsIndexPath.count
        for row in 0..<numberOfRows{
            let ind = IndexPath(row:row,section:index.section)
            if !self.bodyCellsIndexPath.contains(ind) &&
                ind.row < index.row{
                dataIndex+=1
            }
        }
        return dataIndex
    }
    
    func dataForIndex(indexPath: IndexPath) -> T? {
        let dataIndex = self.indexOfDataFor(indexPath: indexPath)
        return self.dataSource[dataIndex]
    }
    
    func performExpandCollapse(atIndexPath indexPath: IndexPath){
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

    }
    
    func expandAtIndex(indexPath: IndexPath){
        let bodyIndex = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        self.refreshBodyCellsIndexPathForState(state: .Expand, atIndex: indexPath)
        self.bodyCellsIndexPath.append(bodyIndex)
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: [bodyIndex], with: .top)
        self.tableView.endUpdates()
    }
    
    func collapseAtIndex(indexPath: IndexPath){
        let bodyIndex = IndexPath(row: indexPath.row + 1, section: indexPath.section)
        self.bodyCellsIndexPath.remove(at: self.bodyCellsIndexPath.index(of: bodyIndex)!)
        self.refreshBodyCellsIndexPathForState(state: .Collapse, atIndex: indexPath)
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [bodyIndex], with: .top)
        self.tableView.endUpdates()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        if self.bodyCellsIndexPath.contains(indexPath) {
            cell = self.delegate.bodyTableViewCell(tableView, cellForRowAt: indexPath)
        }else if indexPath.row < numberOfCells - 1 {
            cell = self.delegate.mainTableViewCell(tableView, cellForRowAt: indexPath)
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "finalCell", for: indexPath)
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row >= numberOfCells - 1 { return }
        self.performExpandCollapse(atIndexPath: indexPath)
        self.delegate.tableView?(tableView, didSelectRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return !(self.bodyCellsIndexPath.contains(indexPath) || indexPath.row >= self.numberOfCells - 1)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = self.delegate.tableView?(tableView, editActionsForRowAt: indexPath)
        let act = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            self.delegate.deleteAtIndex(index: index)
            var rowsToDelete: [IndexPath] = [index]
            let bodyIndex = IndexPath(row: index.row + 1, section: index.section)
            if self.bodyCellsIndexPath.contains(bodyIndex),
                let indexOfBodyCell = self.bodyCellsIndexPath.index(of: bodyIndex){
                rowsToDelete.append(bodyIndex)
                self.refreshBodyCellsIndexPathForState(state: .Remove, atIndex: index)
                self.bodyCellsIndexPath.remove(at: indexOfBodyCell)
            }
            let dataIndex = self.indexOfDataFor(indexPath: index)
            self.dataSource.remove(at: dataIndex)
            tableView.deleteRows(at: rowsToDelete, with: .left)
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
