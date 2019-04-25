//
//  ViewController.swift
//  Todoey
//
//  Created by Manuel on 4/24/19.
//  Copyright © 2019 ManuelRR. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var toDoArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = Item(task: "Read Thrawn")
        toDoArray.append(item1)
        
        let item2 = Item(task: "Read Lords of the Sith")
        toDoArray.append(item2)
        
        let item3 = Item(task: "Read Master and Apprentice")
        toDoArray.append(item3)
        
        if let itemArray = defaults.array(forKey: "ToDoListArray") as? [Item] {
            toDoArray = itemArray
        }
        
    }
    
    // MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = toDoArray[indexPath.row].title
        
        cell.accessoryType = toDoArray[indexPath.row].done ? .checkmark : .none
        
        return cell
        
    }
    
    // MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        toDoArray[indexPath.row].done = !toDoArray[indexPath.row].done
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
                
    }
    
    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey item:", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // What will happen when the Add item button is clicked
            let newItem = Item(task: textField.text!)
            
            self.toDoArray.append(newItem)
            self.defaults.set(self.toDoArray, forKey: "ToDoListArray")
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    

}
