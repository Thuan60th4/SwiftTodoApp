import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    var dataSource : [Item] = []
    let contex = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
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
        
        dataSource[indexPath.row].done = !self.dataSource[indexPath.row].done
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
            self.dataSource.append(work)
            self.SaveItem()
        }
        alertModal.addAction(actionAlert)
        
        present(alertModal, animated: true, completion: nil)
        
        
    }
    
    func SaveItem(){
        do{
            try contex.save()
            tableView.reloadData()
        }
        catch{
            print("error save core data \(error)")
        }
    }
    
    func loadItems(){
        do{
            let req  = Item.fetchRequest()
            self.dataSource = try  contex.fetch(req)
        }
        catch{
            print("query data error \(error)")

        }
        
    }
    
    
}

