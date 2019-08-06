//
//  SwipeTableViewController.swift
//  ToDoApp
//
//  Created by Ario Nugroho on 06/08/19.
//  Copyright © 2019 Ario Nugroho. All rights reserved.
//

import UIKit
import SwipeCellKit

//this is the superclass for categoryviewcontroller and todolistviewcontroller, both category and todolist viewcontroller will inherit everything in this class

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //set the height each cell genererated
        tableView.rowHeight = 80.0
        
        tableView.separatorStyle = .none
       
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // after declaring next syntax make sure "cell" on main.storyboard custom class set to Class name to SwipeTableViewCell and its Module name to SwipeCellKit
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self
        
        //Nil Coalescing Operator
        
//        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Category added yet"
        
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        // declaring on which way the swipe came ie. from right of the screen
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
            
            print("delete cell")
//            if let deletedCategory = self.categoryArray?[indexPath.row]{
//
//                do{
//                    try self.realm.write {
//
//                        self.realm.delete(deletedCategory)
//
//                    }
//                } catch {
//                    print("Error saving done status : \(error)")
//                }
//
//                print("item deleted")
//            }
            
        }
        
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        
        return options
        
    }
    
    //this func will connect all its sub class
    
    func updateModel(at indexPath: IndexPath) {
        //Update Data Model
        print("Item deleted from superclass")
    }
}

    


