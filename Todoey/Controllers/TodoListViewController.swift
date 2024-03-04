import UIKit

class TodoListViewController: UITableViewController {
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(path: "Items.plist")
    
    var itemsList: [Item] = []
    
    //    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if let dataFromDB = defaults.object(forKey: "ToDoListArray") as? [Item] {
        //            itemsList = dataFromDB
        //        }
        
        getItems()
        
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
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        itemsList[indexPath.row].done = !itemsList[indexPath.row].done
        
        
        self.saveItems()
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
                self.saveItems()
                
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems (){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemsList)
            try data.write(to: self.dataFilePath!)
            self.tableView.reloadData()
        }catch{
            print(error)
        }
    }
    
    func getItems (){
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                self.itemsList = try decoder.decode([Item].self, from: data)
            }catch {
                print(error)
            }
        }
        
        
    }
    
    
    func removeItem(index: Int){
        itemsList.remove(at: index)
        saveItems()
    }
}

