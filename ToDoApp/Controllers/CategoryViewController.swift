//
//  CategoryVIewController.swift
//  ToDoApp
//
//  Created by Ario Nugroho on 01/08/19.
//  Copyright © 2019 Ario Nugroho. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categoryArray : Results<Category>?
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        

    }
        
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        //Nil Coalescing Operator
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category added yet"
        
        cell.backgroundColor = UIColor.randomFlat()
        
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
 
        tableView.reloadData()
        
    }
    
    //TODO: - Delete Data from swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        
                    if let deletedCategory = self.categoryArray?[indexPath.row]{
        
                        do{
                            try self.realm.write {
        
                                self.realm.delete(deletedCategory)
        
                            }
                        } catch {
                            print("Error saving done status : \(error)")
                        }
        
                        print("item deleted")
                    }
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

//MARK: - Swipe Cell Delegeta Methods
//
//extension CategoryViewController : SwipeTableViewCellDelegate {
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            // handle action by updating model with deletion
//
//            if let deletedCategory = self.categoryArray?[indexPath.row]{
//
//                do{
//                    try self.realm.write {
//                        //choose which one prefereable realm.delete or item.done
//                        self.realm.delete(deletedCategory)
//                        //item.done = !item.done
//                    }
//                } catch {
//                    print("Error saving done status : \(error)")
//                }
//
//
//
//
////            do{
////                try realm.write {
////                    //choose which one prefereable realm.delete or item.done
////                    //realm.delete(item)
////                    item.done = !item.done
////                }
////            } catch {
////                print("Error saving done status : \(error)")
////            }
//
//                print("item deleted")
//                }
//
//
//
//            }
//        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
//
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//
//        return options
//
//    }
//
//}
