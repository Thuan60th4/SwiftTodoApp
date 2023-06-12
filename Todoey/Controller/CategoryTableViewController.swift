//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Pham Minh Thuan on 28/05/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework


class CategoryTableViewController: SwipeTableViewController {
    
    var listCategory : Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBarSC = navigationController?.navigationBar.scrollEdgeAppearance,let navBarST = navigationController?.navigationBar.standardAppearance
        else{fatalError()}
        
        navBarST.backgroundColor = #colorLiteral(red: 0, green: 0.6924213171, blue: 1, alpha: 1)
        navBarSC.backgroundColor = #colorLiteral(red: 0, green: 0.6924213171, blue: 1, alpha: 1)
    }
    
    //MARK: - TableView data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCategory?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = listCategory?[indexPath.row].name
        if let color = UIColor(hexString: (listCategory?[indexPath.row].color)!){
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            
        }
        
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
                destinationViewController.selectedCategory = listCategory?[indexPath.row]
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
            let category = Category()
            category.name = alertTextField!.text!
            category.color = UIColor.randomFlat().hexValue()
            self.saveCategory(category)
        }
        
        addCategoryModal.addAction(actionModal)
        present(addCategoryModal, animated: true, completion: nil)
    }
    
    
    //MARK: - data action from database
    
    func saveCategory(_ category : Category){
        do {
            try realm.write({
                realm.add(category)
            })
            tableView.reloadData()
        } catch {
            print("Save category error \(error)")
        }
    }
    
    func loadCategories(){
        listCategory = realm.objects(Category.self)
        tableView.reloadData()
        //        do {
        //            let request = NSFetchRequest<Category>(entityName: "Category")
        //            listCategory = try context.fetch(request)
        //            tableView.reloadData()
        //        } catch  {
        //            print("Get category list error \(error)")
        //        }
    }
    
    override func updateDatasource(at indexPath: IndexPath) {
        if let category = listCategory?[indexPath.row] {
            do {
                try self.realm.write({
                    self.realm.delete(category)
                    // ko đuọc gọi cái này vì sau khi chúng ta xoá 1 phần tử khỏi mảng,chúng ta reset lại mảng thì cái hành động delegate bên dưới sẽ lỗi vì nó ko bt được cái indexPath đó là gì để mà xoá
                    //                        tableView.reloadData()
                })
            } catch  {
                print("delete category error \(error)")
            }
        }
    }
    
}

//MARK: - Swipe Cell
//extension CategoryTableViewController : SwipeTableViewCellDelegate{
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            if let category = self.listCategory?[indexPath.row] {
//                do {
//                    try self.realm.write({
//                        self.realm.delete(category)
//                        // ko đuọc gọi cái này vì sau khi chúng ta xoá 1 phần tử khỏi mảng,chúng ta reset lại mảng thì cái hành động delegate bên dưới sẽ lỗi vì nó ko bt được cái indexPath đó là gì để mà xoá
////                        tableView.reloadData()
//                    })
//                } catch  {
//                    print("delete category error \(error)")
//                }
//            }
//        }
//        return [deleteAction]
//    }
//
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        return options
//    }
//
//}

