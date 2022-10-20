//
//  ItemsViewController.swift
//  ToDoey
//
//  Created by Mihai Gorgan on 13.10.2022.
//

import UIKit
import RealmSwift
import ChameleonFramework


class ToDoListViewController: SwipeTableViewController, UISearchBarDelegate {
    
    var toDoItems: Results<Item>?
    
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func updateModel(at indexPath: IndexPath) {
        do {
            try self.realm.write({
                self.realm.delete(self.toDoItems![indexPath.row])
            })
        } catch {
            print("Error Delete Item === \(error)")
            
        }
    }
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.barTintColor = UIColor(hexString: selectedCategory!.backrounColor)
        
        searchBar.searchTextField.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 0.9999999404, alpha: 1)
        
        searchBar.searchTextField.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        
        
        navigationMenuBar(navigationItem: navigationItem, bkColor: selectedCategory!.backrounColor, title: selectedCategory!.name)
        
//        `navigationItem`.ri                    ghtBarButtonItem?.tintColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: selectedCategory!.backrounColor)!, isFlat: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar else{fatalError("Nav Control")}
        //navBar.tintColor = ContrastColorOf(UIColor(hexString: selectedCategory!.backrounColor)!, returnFlat: true) shortcut deprecated
        navBar.tintColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: selectedCategory!.backrounColor)!, isFlat: true)
    }
    
     //MARK: - Add New Items
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        
        var textFieldRef = UITextField()
        
        let alert = UIAlertController(title: "--Adaugare elemente--", message: "O sa adaugi un element", preferredStyle: .alert)
        let action = UIAlertAction(title: "Adauga Element?", style: .default) { (action) in
                 
            
            if let currentCategory = self.selectedCategory {
                                
                do {
                    try self.realm.write({
                        let newItem = Item()
                        newItem.title = textFieldRef.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    })
                } catch {
                    print("Error Save newItem === \(error)")
                    
                }
                
            }
            self.tableView.reloadData()
        }
        
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Item"
            textFieldRef = alertTextField
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    

}


//MARK: - Table Datasource Methods
extension ToDoListViewController {
        
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    // repete for each cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
            let color: UIColor = UIColor(hexString: selectedCategory!.backrounColor)!
            
            //let bkColor = color.darken(byPercentage: CGFloat((Float(indexPath.row)/Float(toDoItems!.count)) * 2))
            
            let CGValue = Float(indexPath.row) / Float(toDoItems!.count) / 4.0
                                    
            let bkColor = color.darken(byPercentage: CGFloat(CGValue))
                                   
            cell.backgroundColor = bkColor
            
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn: bkColor!, isFlat: true)
            
            
            
        }else{
            cell.textLabel?.text = "No Items Added"
        }
         
        return cell
    }
    
    // Select event
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if let item = toDoItems?[indexPath.row] {
            do {
                try realm.write({
                    item.done = !item.done
                    //self.realm.delete(item)
                    
                 
                })
            } catch {
                print("Error Save Mod === \(error)")
                
            }
        }
                
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
  
    func loadItems(){
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }

    
}
    


//MARK: - Navigation Bar Color
func navigationMenuBar(navigationItem: UINavigationItem, bkColor: String, title: String) {
    
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = UIColor(hexString: bkColor)
    let textColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: bkColor)!, isFlat: true)
    appearance.largeTitleTextAttributes = [.foregroundColor: textColor!]
    appearance.titleTextAttributes = [.foregroundColor: textColor!]
     
    
    navigationItem.standardAppearance = appearance
    navigationItem.scrollEdgeAppearance = appearance
    navigationItem.title = title.capitalizingFirstLetter()
}

//MARK: - Search Bar methods
extension ToDoListViewController {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text!.count > 0 {

            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
            
            tableView.reloadData()
            
        }
    }
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            tableView.reloadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
    
    
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
