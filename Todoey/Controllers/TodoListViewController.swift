import UIKit

class TodoListViewController: UITableViewController {
    
    //    var itemArray = ["Complete Local Database","Learn Almofire","Complete App with VIPER"]
    var itemsList = [
        Item("Complete Local Database"),
        Item("Learn Almofire"),
        Item("Complete App with VIPER"),
        Item("Completed ?"),
        Item("You are now an iOS Developer 🥵✅")
    ]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let dataFromDB = defaults.object(forKey: "ToDoListArray") as? [Item] {
            itemsList = dataFromDB
        }
        
        
        tableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemsList[indexPath.row]
        
        cell.textLabel?.text = item.title
        
         cell.accessoryType =  item.done ? .checkmark : .none
        
        
        return cell
    }
    
    
    // method triggerd when select a cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //animate deselect
        tableView.deselectRow(at: indexPath, animated: true)
        //change accessoryType
        
        
        itemsList[indexPath.row].done = !itemsList[indexPath.row].done
        
        tableView.reloadData()
    }
    
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem) {
        
        var textField: UITextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            textField.placeholder = "Enter task"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            if let text = textField.text {
                self.itemsList.append(Item(text))
            }
            
            
            self.defaults.set(self.itemsList, forKey: "ToDoListArray")
            
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

