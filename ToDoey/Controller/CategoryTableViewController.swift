//
//  ViewController.swift
//  ToDoey
//
//  Created by Mihai Gorgan on 12.10.2022.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    
    var categories: Results<Category>?
       
    override func viewDidLoad() {
        super.viewDidLoad()
             
        navigationMenuBar(navigationItem: navigationItem, bkColor: "017bff")

        loadCategories()
        
        
    }
    
    
    
    
    //MARK: - Table View Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
              
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
                
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
        
        DispatchQueue.main.async {
            cell.backgroundColor = UIColor(hexString: self.categories?[indexPath.row].backrounColor ?? "#c62fa1")
            cell.textLabel?.textColor = UIColor(contrastingBlackOrWhiteColorOn:
            UIColor(hexString: self.categories?[indexPath.row].backrounColor ?? "#c62fa1")!,
            isFlat: true)
        }
        
        return cell
        
    }
    
    
    
    
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
        
        
    }
    
    
           
    //MARK: - Data Manipulation Methods
    func save(category : Category) {
                        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("Error Save Category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories() {
   
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    //Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        
        do {
            try self.realm.write({
                self.realm.delete(self.categories![indexPath.row])
                //tableView.reloadData()
            })
        } catch {
            print("Error Delete Category === \(error)")

        }
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPrsd(_ sender: UIBarButtonItem){
        var textFieldRef = UITextField()
        let alert = UIAlertController(title: "-- Add Category --", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add New Category", style: .default) { (action) in
                                    
            let newCategory = Category()
            newCategory.name = textFieldRef.text!
            newCategory.backrounColor = UIColor.randomFlat().hexValue()
            print("=========  Hex : \(newCategory.backrounColor)")
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Category Name"
            textFieldRef = alertTextField
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
   
    func navigationMenuBar(navigationItem: UINavigationItem, bkColor: String) {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(hexString: bkColor)
        let textColor = UIColor(contrastingBlackOrWhiteColorOn: UIColor(hexString: bkColor)!, isFlat: true)
        appearance.largeTitleTextAttributes = [.foregroundColor: textColor!]
        appearance.titleTextAttributes = [.foregroundColor: textColor!]

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.9290366769, green: 0.9463012815, blue: 0.9493255019, alpha: 1)
    }
}
