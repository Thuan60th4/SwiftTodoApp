import UIKit
import CoreData
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    var dataSource : Results<Item>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - tableView dataSource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataSource?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = dataSource?[indexPath.row].title
        cell.accessoryType =  self.dataSource?[indexPath.row].done ?? false ? .checkmark : .none
        return cell
    }
    
    //MARK: - tableView delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        do {
            try realm.write({
                self.dataSource?[indexPath.row].done = !self.dataSource![indexPath.row].done
            })
        } catch {
            print("Checked box error \(error)")
        }
        
        tableView.reloadData()
        
        //Update item
        //        dataSource[indexPath.row].done = !self.dataSource[indexPath.row].done
        //remove item
        //        contex.delete(dataSource[indexPath.row])
        //        dataSource.remove(at: indexPath.row)
        //        SaveItem()
        
        
        //  nó là option nil nên ta phải viết .accessoryType bên dưới ý là chắc gì nó đã có mà .accessoryType
        //  if let refCell = tableView.cellForRow(at: indexPath)
        //     {
        //               refCell.accessoryType = self.dataSource[indexPath.row].done ? .checkmark : .none
        //     }
        
        
    }
    //MARK: - Add ToDo Item
    
    @IBAction func addTodoItem(_ sender: UIBarButtonItem) {
        var textField : UITextField?
        let alertModal = UIAlertController(title: "Add work", message: nil, preferredStyle: .alert)
        
        alertModal.addTextField { alertInput in
            alertInput.placeholder = "Type your work"
            textField = alertInput
        }
        
        let actionAlert = UIAlertAction(title: "Add", style: .default) { action in
            let item = Item()
            item.title = textField!.text!
            self.SaveItem(item)
        }
        alertModal.addAction(actionAlert)
        
        present(alertModal, animated: true, completion: nil)
        
        
    }
    
    
    //MARK: - Load database
    
    func SaveItem(_ item : Item){
        do{
            try realm.write {
                selectedCategory?.items.append(item)
            }
            tableView.reloadData()
        }
        catch{
            print("error save core data \(error)")
        }
    }
    
    func loadItems(){
        dataSource = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    override func updateDatasource(at indexPath: IndexPath) {
        do {
            if let todoItem = dataSource?[indexPath.row] {
                try realm.write({
                    realm.delete(todoItem)
                })
            }
        } catch {
            print("delete todo item error \(error)")
        }
    }
    
}

//MARK: - Query database with text in searchBar
extension ToDoListViewController : UISearchBarDelegate{
    // chúg ta ko cần khởi tạo 1 UISearchbar trong ToDoListViewController rồi gán nó.delegate = self nữa vì đã nối trực tiếp searchBar vs cái ToDoListViewController trong mainStoryboard rồi
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dataSource = dataSource?.filter("title CONTAINS[cd] %@", searchBar.text!)
        tableView.reloadData()
        
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItems()
        }
    }
    
}


