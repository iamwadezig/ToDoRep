//
//  ViewController.swift
//  ToDoApp
//
//  Created by Ario Nugroho on 27/07/19.
//  Copyright © 2019 Ario Nugroho. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {

//    var itemArray = [Item]()
    
    var toDoItems : Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        
        didSet{
            
            // will be executed when selectedCategory has value and then it will load items
            
            loadItems()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //calling its superclass which is swipeviewtablecontroller
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            
        } else {
            
            cell.textLabel?.text = "No Items Added Yet"
        }
        
        //following syntax are far more efficient but it is hard to read
        //cell.textLabel?.text = toDoItems?[indexPath.row].title ?? "No Item added yet"
        //cell.accessoryType = (toDoItems?[indexPath.row].done)! ? .checkmark : .none
        
        return cell

    }
    
    //setting number of row
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if it has value (not nil) it will return todoitems.count if its nil it will return 1
        return toDoItems?.count ?? 1
        
    }

    //MARK: - TableView Delegate Methods
    
    //MARK: - Func to perform action on cell when selected
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = toDoItems?[indexPath.row] {
            do{
                try realm.write {
                    //choose which one prefereable realm.delete or item.done
                    //realm.delete(item)
                    //this will change status on accesories in each cell when selected
                    item.done = !item.done
                    print("status changed")
                }
            } catch {
                print("Error saving done status : \(error)")
            }
        }
        
        //always reload after modify
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items into realm then to persistent database
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
        
            // what will happen one the user clicks the Add Item button on our UIAlert
          
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        //grabbing the text in textfield
                        newItem.title = textField.text!
                        // grabbing the date the item created
                        newItem.dateCreated = Date()
                        // saving into realm database
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
    
            }
            
            self.tableView.reloadData()
            
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = " Create new item"
            textField = alertTextField
          
        //TODO: - Adding cancel button to cancel input new data
            
            
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
                action in
                
                // Called when user taps outside
                
                self.loadItems()
            
            }))
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    //MARK: - Loads Items from persistent database via context
    
    func loadItems() {

        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }
    
    //TODO: - Delete Data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
        if let deletedItem = self.toDoItems?[indexPath.row]{
            
            do{
                try self.realm.write {
                    
                    self.realm.delete(deletedItem)
                    
                }
            } catch {
                print("Error saving done status : \(error)")
            }
            
            print("item deleted")
        }
    }
}

    //MARK: - Search bar Methods

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        //toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        // we dont need to load items like when using core data coz we already load items on selected category
        
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
    
}







// this is when using coredata SQLite
//extension ToDoListViewController : UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        // ada proses dalam pembuatan syntax di bawah liat videonya
//
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(with: request, predicate: predicate)
//
//    }
//
//    //MARK: - Search Bar when no Text Methods
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//    // when there are no texts on searchbar, then load all items and resign keyboard and cursor
//
//        if searchBar.text?.count == 0 {
//
//            loadItems()
//
//            DispatchQueue.main.async {
//
//                searchBar.resignFirstResponder()
//
//            }
//
//        }
//    }
//
//}

