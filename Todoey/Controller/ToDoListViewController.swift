import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    var dataSource : [Item] = []
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - tableView dataSource method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = dataSource[indexPath.row].title
        cell.accessoryType =  self.dataSource[indexPath.row].done ? .checkmark : .none
        return cell
    }
    
    //MARK: - tableView delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Update item
        dataSource[indexPath.row].done = !self.dataSource[indexPath.row].done
        //remove item
        //        contex.delete(dataSource[indexPath.row])
        //        dataSource.remove(at: indexPath.row)
        SaveItem()
        
        
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
            let work = Item(context: self.contex)
            work.title = (textField!).text!
            //thêm cả th parentcategory trong relationship vào nữa để nó match vs th category được chọn
            work.parentcategory = self.selectedCategory
            self.dataSource.append(work)
            self.SaveItem()
        }
        alertModal.addAction(actionAlert)
        
        present(alertModal, animated: true, completion: nil)
        
        
    }
    
    
    //MARK: - Load database
    
    func SaveItem(){
        do{
            try contex.save()
            tableView.reloadData()
        }
        catch{
            print("error save core data \(error)")
        }
    }
    
    func loadItems(with request :NSFetchRequest<Item> = NSFetchRequest<Item>(entityName: "Item")
                   ,predicate : NSPredicate? = nil
    ){
        do{
        //tham khảo mấy cái truy vấn của coreData ở đây  https://nshipster.com/nspredicate/
            
            let categoryPredicate = NSPredicate(format: "parentcategory.name MATCHES %@ ", selectedCategory!.name!)
            
            if let additionPredicate = predicate {
                
                let combinePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionPredicate])
                
                request.predicate = combinePredicate
            }
            else{
                request.predicate = categoryPredicate
            }
            
            dataSource = try contex.fetch(request)
            tableView.reloadData()
        }
        catch{
            print("query data error \(error)")
        }
    }
}

//MARK: - Query database with text in searchBar
extension ToDoListViewController : UISearchBarDelegate{
    // chúg ta ko cần khởi tạo 1 UISearchbar trong ToDoListViewController rồi gán nó.delegate = self nữa vì đã nối trực tiếp searchBar vs cái ToDoListViewController trong mainStoryboard rồi
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request = NSFetchRequest<Item>(entityName: "Item")
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors=[NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request,predicate: predicate)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            searchBar.resignFirstResponder()
            loadItems()
        }
    }
    
}


