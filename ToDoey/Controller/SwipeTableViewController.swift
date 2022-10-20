//
//  SwipeTableViewController.swift
//  ToDoey
//
//  Created by Mihai Gorgan on 20.10.2022.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
        
    var cell: UITableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70.0
    }
    
    //TableViewData Source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
        
        cell.delegate = self
                        
        return cell
        
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            
        print("Delete Cell")
          
        self.updateModel(at: indexPath)

          
        }
        
        deleteAction.image = UIImage(systemName: "trash.fill")
                
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border
        return options
    }
    
    
    func updateModel(at indexPath : IndexPath) {
        // Update data model
    }
    
    
    
    
    
}

