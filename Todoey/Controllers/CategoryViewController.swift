//
//  CategoryViewController.swift
//  Todoey
//
//  Created by bilal on 05/03/2024.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    var categoryList : [Category] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCategories()
        tableView.delegate = self
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let catItem = categoryList[indexPath.row]
        
        cell.textLabel?.text = catItem.name
        
        
        return cell
    }
    
    //MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = self.categoryList[indexPath.row]
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            textField.placeholder = "Enter Category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let text = textField.text {
                
                self.setNewItem(text)
                
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (action) in
             
        }
        
        alert.addAction(action)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    //MARK: - Data manipulation
    
    func getCategories(_ request : NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            self.categoryList = try context.fetch(request)
        }catch{
            print(error)
        }
    }
    
    func saveItems (){
        do{
            try context.save()
            self.tableView.reloadData()
        }catch{
            print(error)
        }
    }
    
    func setNewItem (_ name: String){
        
        let nItem = Category(context: context)
        
        nItem.name = name
        
        self.categoryList.append(nItem)
        
        self.saveItems()
    }
    
    func removeItem(index: Int){
        let itemToRemove = categoryList[index]
        self.context.delete(itemToRemove)
        categoryList.remove(at: index)
        saveItems()
    }

}
