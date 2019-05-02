//
//  ViewController.swift
//  Todoey
//
//  Created by Manuel on 4/24/19.
//  Copyright © 2019 ManuelRR. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {

    let realm = try! Realm()
    var todoItems : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let categoryColorCode = selectedCategory?.backgroundColor else {fatalError()}
        
        title = selectedCategory?.name
        
        updateNavBar(withHexCode: categoryColorCode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "#011993")
    }
    
    
    //MARK: - NavBar setup methods
    
    func updateNavBar(withHexCode colorCode: String) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist")}
        
        guard let categoryColor = UIColor(hexString: colorCode) else {fatalError()}
        
        navBar.barTintColor = categoryColor
        navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: categoryColor, isFlat: true)
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn: categoryColor, isFlat: true)]
        searchBar.barTintColor = categoryColor
    }
    
    
    // MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.backgroundColor = UIColor(hexString: selectedCategory!.backgroundColor)?.darken(byPercentage: (CGFloat(indexPath.row)/CGFloat(todoItems!.count)))
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:cell.backgroundColor!, isFlat:true)
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added yet"
        }
        
        return cell
    }
    
    
    // MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        actionToAddOrEdit(alertTitle: "Add new Todoey item:", placeholderText: "Create new item", actionText: "Add", indexPath: nil)
    }
    
    
    //MARK: - Model manipulation methods
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    override func editDataInModel(at indexPath: IndexPath) {
        
        actionToAddOrEdit(alertTitle: "Edit item:", placeholderText: "Item to edit", actionText: "Edit", indexPath: indexPath)
    }
    
    
    //MARK: Data deletion using swipe
    
    override func deleteDataInModel(at indexPath: IndexPath) {
        
        if let itemToDelete = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch {
                print("Error deleting item, \(error)")
            }
        }
    }
}


//MARK: - Search bar methods

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    
    //MARK: - Create add or edit method with alert
    
    func actionToAddOrEdit(alertTitle: String, placeholderText: String, actionText: String, indexPath: IndexPath?) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: actionText, style: .default) { (action) in
            
            if actionText == "Add" {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error saving new item, \(error)")
                    }
                }
                
                self.tableView.reloadData()
            }
            else if actionText == "Edit" {
                
                if let itemToEdit = self.todoItems?[(indexPath?.row)!] {
                    do {
                        try self.realm.write {
                            itemToEdit.title = textField.text!
                        }
                    } catch {
                        print("Error editing item, \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = placeholderText
            textField = alertTextField
            if actionText == "Edit" {
                textField.text = self.todoItems?[(indexPath?.row)!].title
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
