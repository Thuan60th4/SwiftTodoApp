//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Pham Minh Thuan on 28/05/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    var listCategory : [Category] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    //MARK: - TableView data
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCategory.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = listCategory[indexPath.row].name
        return cell
        
    }
    
    //MARK: - Table delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToListItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToListItem" {
            let destinationViewController = segue.destination as! ToDoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationViewController.selectedCategory = listCategory[indexPath.row]
            }
        }
    }
    
    //MARK: - Alert action

    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var alertTextField : UITextField?
        
        let addCategoryModal = UIAlertController(title: "Add category", message: nil, preferredStyle: .alert)
        
        addCategoryModal.addTextField { textField in
            textField.placeholder="Add your category"
            alertTextField = textField
        }
        
        let actionModal = UIAlertAction(title: "Add", style: .default) { action in
            let category = Category(context: self.context)
            category.name = alertTextField!.text
            self.listCategory.append(category)
            self.saveCategory()
        }
        
        addCategoryModal.addAction(actionModal)
        present(addCategoryModal, animated: true, completion: nil)
    }
    
    
    //MARK: - data action from database
    
    func saveCategory(){
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Save category error \(error)")
        }
    }
    
    func loadCategories(){
        do {
            let request = NSFetchRequest<Category>(entityName: "Category")
            listCategory = try context.fetch(request)
            tableView.reloadData()
        } catch  {
            print("Get category list error \(error)")
        }
    }
    
}
