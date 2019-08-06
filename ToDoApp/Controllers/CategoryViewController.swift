//
//  CategoryVIewController.swift
//  ToDoApp
//
//  Created by Ario Nugroho on 01/08/19.
//  Copyright © 2019 Ario Nugroho. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //Nil Coalescing Operator
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category added yet"
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //if categoryArray not nil  then return category.count if its nil then return 1. This is called nil coalescing operator
        
        return categoryArray?.count ?? 1
        
    }
    
    //MARK: - Data Manipulation Methods
    
    //TODO: - Saving Methods with Realm
    
    func save(category: Category) {
        
        do {
            
            try realm.write {
                realm.add(category)
            }
            
            
        } catch {
            
            print("Error saving context : \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //TODO: - Loading Category List to View
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)

//      use next when using datacore (SQLite)
//
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//        
//        do {
//            
//            categoryArray = try context.fetch(request)
//            
//        } catch {
//            
//            print("Error fetching data from context : \(error)")
//            
//        }
//        
 
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Categories
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
   
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // what will happen one the user clicks the Add Item button on our UIAlert
            
            let newCategory = Category()
            
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        
        //TODO: - Adding placeholder(place you type input
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = " Create new Category"
            textField = alertTextField
            
            
        }
        
        //TODO: - Adding cancel button to cancel input new data
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            
            self.loadCategories()
            
        }))
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    
    //MARK: - TableVIew Delegate Methods, when cell selected perform segue
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "goToItems", sender: self)
        
        
    }
    
    //prep before segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {

            // this one doesnt need nil coalescing operator, because in ToDoViewController we have var selectedCategory which trigger when its not nil, so when its nil it wont trigger.
            
            destinationVC.selectedCategory = categoryArray?[indexPath.row]

        }
    }
}
