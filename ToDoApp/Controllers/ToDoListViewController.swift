//
//  ViewController.swift
//  ToDoApp
//
//  Created by Ario Nugroho on 27/07/19.
//  Copyright © 2019 Ario Nugroho. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        
        didSet{
            // will be executed when selectedCategory has value
            loadItems()
            
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator =>
        // value = condition ? valueTrue : valueFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }

    //MARK: - TableView Delegate Methods
    
    //MARK: - Func to perform action on cell when selected
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //syntax satu line dibawah untuk mengubah title menjadi complete ketika sudah done
        
        //itemArray[indexPath.row].setValue("Complete", forKey: "title")
        
        //untuk keperluan app ini satu line berikut sudah cukup (user experience lebih bagus)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //to delete data inside persistent container
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        // animate when cell selected
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add New Items into context then to persistent database via saveItem()
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new to do item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
        
            // what will happen one the user clicks the Add Item button on our UIAlert
            
        let newItem = Item(context: self.context)
            
        newItem.title = textField.text!
            
        newItem.done = false
            
        newItem.parentCategory = self.selectedCategory
            
        self.itemArray.append(newItem)
            
        self.saveItems()
            
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
    
    //MARK: - Save Items into persistent database from context
    
    
    func saveItems() {
        
        
        
        do {
            
        try context.save()
            
            
        } catch {
            
            print("Error saving context : \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    //MARK: - Loads Items from persistent database via context
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
        } else {
          
            request.predicate = categoryPredicate
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate])
//
//        request.predicate = compoundPredicate
        
        
        do {
            
            itemArray = try context.fetch(request)
            
        } catch {
            
            print("Error fetching data from context : \(error)")
            
        }

        tableView.reloadData()
        
    }
    
}

    //MARK: - Search bar Methods

extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // ada proses dalam pembuatan syntax di bawah liat videonya
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    
    }
    
    //MARK: - Search Bar when no Text Methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    // when there are no texts on searchbar, then load all items and resign keyboard and cursor
        
        if searchBar.text?.count == 0 {
            
            loadItems()
            
            DispatchQueue.main.async {
                
                searchBar.resignFirstResponder()
                
            }
            
        }
    }
    
}

