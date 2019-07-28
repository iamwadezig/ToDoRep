//
//  ViewController.swift
//  ToDoApp
//
//  Created by Ario Nugroho on 27/07/19.
//  Copyright © 2019 Ario Nugroho. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    let itemArray = ["buy apple", "buy mango", "buy pen"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }

    //MARK: - TableView Delegate Methods
    
//  func to perform action on cell when selected
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
// animate when cell selected
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//  when click cell if there's checkmark it will disable checkmark vice versa
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        
    }
    
}

