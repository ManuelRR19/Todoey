//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Manuel on 4/27/19.
//  Copyright © 2019 ManuelRR. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    var categoryArray : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        loadCategories()
    }
    
    
    // MARK: - TableView datasource methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added yet"
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].backgroundColor ?? "#FFFFFF")
        cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:cell.backgroundColor!, isFlat:true)

        return cell
    }
    
    
    // MARK: - TableView delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if categoryArray?[indexPath.row].name != nil {
            performSegue(withIdentifier: "goToItems", sender: self)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }


    //MARK: - Add new category
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        actionToAddOrEdit(alertTitle: "Add a new category:", placeholderText: "Create new category", actionText: "Add", indexPath: nil)
        
    }
    
    //MARK: - Model manipulation methods
    
    func saveCategories(_ category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categories, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func editDataInModel(at indexPath: IndexPath) {
        
        actionToAddOrEdit(alertTitle: "Edit category:", placeholderText: "Category to edit", actionText: "Edit", indexPath: indexPath)
    }


    //MARK: - Data deletion using swipe
    
    override func deleteDataInModel(at indexPath: IndexPath) {
        
        if let categoryToDelete = categoryArray?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryToDelete)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
}


//MARK: - Create add or edit method with alert

extension CategoryViewController {
    
    func actionToAddOrEdit(alertTitle: String, placeholderText: String, actionText: String, indexPath: IndexPath?) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let action = UIAlertAction(title: actionText, style: .default) { (action) in
            
            if actionText == "Add" {
                
                let newCategory = Category()
                newCategory.name = textField.text!
                newCategory.backgroundColor = UIColor.randomFlat.hexValue()
                
                self.saveCategories(newCategory)
            }
            else if actionText == "Edit" {
                
                if let categoryToEdit = self.categoryArray?[(indexPath?.row)!] {
                    do {
                        try self.realm.write {
                            categoryToEdit.name = textField.text!
                        }
                    } catch {
                        print("Error editing category, \(error)")
                    }
                }
                self.tableView.reloadData()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = placeholderText
            textField = alertTextField
            if actionText == "Edit" {
                textField.text = self.categoryArray?[(indexPath?.row)!].name
            }
        }
        
        alert.addAction(cancel)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}
