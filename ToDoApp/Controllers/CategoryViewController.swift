//
//  CategoryVIewController.swift
//  ToDoApp
//
//  Created by Ario Nugroho on 01/08/19.
//  Copyright © 2019 Ario Nugroho. All rights reserved.
//

import UIKit
import CoreData


class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    //MARK: - Data Manipulation Methods
    
    //TODO: - Saving Category List to Persistent DB
    
    func saveCategories() {
        
        do {
            
            try context.save()
            
            
        } catch {
            
            print("Error saving context : \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //TODO: - Loading Category List to View
    
    func loadCategories() {
        
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            
            categoryArray = try context.fetch(request)
            
        } catch {
            
            print("Error fetching data from context : \(error)")
            
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add New Categories
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
   
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // what will happen one the user clicks the Add Item button on our UIAlert
            
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text!
            
            self.categoryArray.append(newCategory)
            
            self.saveCategories()
            
        }
        
        
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = " Create new Category"
            textField = alertTextField
            
            
        }
        
    //TODO: - Adding cancel button to cancel input new data
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            
            // Called when user taps outside
            
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

            destinationVC.selectedCategory = categoryArray[indexPath.row]

        }
    }
}
