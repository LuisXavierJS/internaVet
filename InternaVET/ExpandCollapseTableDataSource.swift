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
    func bodyCellSelected(at index: IndexPath)
}

class ExpandCollapseTableManager<T:NSManagedObject>: NSObject, UITableViewDataSource, UITableViewDelegate{
    
    typealias DataMap = (index:Int,id:Int)
    
    var modelDataSource:[T] = []{
        didSet{
            self.mapDataSource = []
            self.reloadMapDataSource()
        }
    }
    var mapDataSource:[DataMap] = [] // mapeamento de index para o modelDataSource
    var bodyCellsIndexPath: [IndexPath] = []
    var numberOfCells: Int {
        return self.mapDataSource.count + self.bodyCellsIndexPath.count + 1
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
    
    func reloadMapDataSource(){
        var index: Int = 0
        for model in modelDataSource{
            if model is Tarefa{
                let ocorrenciasDaTarefa = (model as! Tarefa).getListaDeDosesPendentes().count
                for ocorrencia in 0..<min(3,ocorrenciasDaTarefa){
                    self.mapDataSource.append((index,ocorrencia))
                }
            }else{
                self.mapDataSource.append((index,0))
            }
            index+=1
        }
        self.sortMapDataSource()
    }
    
    func sortMapDataSource(){
        if self.modelDataSource is [Tarefa] {
            self.mapDataSource.sort(by: { (map1, map2) -> Bool in
                if let tarefa1 = self.modelDataSource[map1.index] as? Tarefa,
                    let tarefa2 = self.modelDataSource[map2.index] as? Tarefa,
                    let data1 = tarefa1.getDataDaAplicacaoDeNumero(numeroDaAplicacao: map1.id),
                    let data2 = tarefa2.getDataDaAplicacaoDeNumero(numeroDaAplicacao: map2.id){
                    return data1 < data2
                }
                return true
            })
        }
    }
    
    func refreshData(withData: [T]? = nil){
        self.bodyCellsIndexPath = []
        self.modelDataSource = withData ?? CoreDataManager.fetchRequest(T.self)
        self.tableView.reloadData()
    }
    
    func dataMapForIndexPath(indexPath: IndexPath) -> DataMap {
        var index = indexPath
        if self.bodyCellsIndexPath.contains(indexPath){
            index = IndexPath(row:index.row - 1, section: index.section)
        }
        var dataIndex: Int = 0
        let numberOfRows = self.numberOfCells - 1
        for row in 0..<numberOfRows{
            let ind = IndexPath(row:row,section:index.section)
            if !self.bodyCellsIndexPath.contains(ind) &&
                ind.row < index.row{
                dataIndex+=1
            }
        }
        return self.mapDataSource[dataIndex]
    }
    
    func indexOfDataFor(indexPath: IndexPath) -> Int{
        return dataMapForIndexPath(indexPath: indexPath).index
    }
    
    func dataForIndex(indexPath: IndexPath) -> T? {
        let dataIndex = self.indexOfDataFor(indexPath: indexPath)
        return self.modelDataSource[dataIndex]
    }
    
    func performExpandCollapse(atIndexPath indexPath: IndexPath){
        DispatchQueue.main.async {
            if !self.bodyCellsIndexPath.contains(indexPath) &&
                self.delegate.shouldExpandCollapse(self.tableView, forRowAt: indexPath){
                let bodyIndex = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                if self.bodyCellsIndexPath.contains(bodyIndex){
                    self.collapseAtIndex(indexPath: indexPath)
                }else{
                    self.expandAtIndex(indexPath: indexPath)
                }
                print("did expand collapse")
            }else{
                self.delegate.bodyCellSelected(at: indexPath)
            }
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
    
    //DELETAR -> DELETA TODAS E DEPOIS RELOAD NA TELA INTEIRA (COMO SE ESTIVESSE REAPARECENDO DO ZERO)
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var actions = self.delegate.tableView?(tableView, editActionsForRowAt: indexPath)
        let act = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
            self.delegate.deleteAtIndex(index: index)
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
