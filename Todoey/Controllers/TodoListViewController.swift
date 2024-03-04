import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: "Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    var itemsList: [Item] = []
    
    
    //    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if let dataFromDB = defaults.object(forKey: "ToDoListArray") as? [Item] {
        //            itemsList = dataFromDB
        //        }
        
        getItems()
        
        tableView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: - setting number of items in list
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    //MARK: - create cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemsList[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType =  item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK: - on select item
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemsList[indexPath.row].done = !itemsList[indexPath.row].done
        
        
        self.saveItems()
        
        
    }
    
    //MARK: - add new items
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            textField.placeholder = "Enter task"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let text = textField.text {
                
                self.setNewItem(text)
                
                
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    //MARK: - save items : C in CRUD
    
    func saveItems (){
        do{
            try context.save()
            self.tableView.reloadData()
        }catch{
            print(error)
        }
    }
    
    
    //MARK: - get items : R in CRUD
    
    func getItems (){
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        self.loadItem(request)
    }
    
    
    //MARK: - remove items : D in CRUD
    func removeItem(index: Int){
        let itemToRemove = itemsList[index]
        self.context.delete(itemToRemove)
        itemsList.remove(at: index)
        saveItems()
    }
    
    //MARK: - set new item
    
    func setNewItem (_ title: String, _ done: Bool = false){
        
        let nItem = Item(context: context)
        
        nItem.title = title
        
        nItem.done = done
        
        self.itemsList.append(nItem)
        
        self.saveItems()
    }
    
    @IBAction func performeDelete(_ sender: Any) {
        
        guard let button = sender as? UIButton,
              let cell = button.superview?.superview as? UITableViewCell else {
            return
        }
        
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let index = indexPath.row
        removeItem(index: index)
        
    }
    
}


//MARK: - SearchBar Delegate

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
            if searchBar.text != "" {

                let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)

                request.predicate = predicate

                let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)

                request.sortDescriptors = [sortDescriptor]

                self.loadItem(request)
            }else{
                request.predicate = nil
                self.loadItem(request)
            }
        tableView.reloadData()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
            
        
            
        
        
    }
    
    //MARK: - textChange
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        
            if searchBar.text != "" {
                
                let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
                
                request.predicate = predicate
                
                let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
                
                request.sortDescriptors = [sortDescriptor]
                
                self.loadItem(request)
            }else{
                request.predicate = nil
                self.loadItem(request)
            }
            
            tableView.reloadData()
            
        
    }
    
    func loadItem(_ request : NSFetchRequest<Item>){
        do{
             self.itemsList = try context.fetch(request)
        }catch{
            print(error)
        }
    }
}
