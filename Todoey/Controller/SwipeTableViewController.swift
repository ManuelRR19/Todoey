//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Manuel on 4/29/19.
//  Copyright © 2019 ManuelRR. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 70
    }
    
    //MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
                
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.deleteDataInModel(at: indexPath)
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        let editAction = SwipeAction(style: .default, title: "Edit") { (action, indexPath) in
            self.editDataInModel(at: indexPath)
        }
        
        editAction.backgroundColor = UIColor.flatOrange
        
        return [deleteAction, editAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func editDataInModel(at indexPath: IndexPath) {
        //Update data model
    }
    
    func deleteDataInModel(at indexPath: IndexPath) {
        //Update data model
    }
}
