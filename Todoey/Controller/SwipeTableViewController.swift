//
//  SwipeTableViewCellController.swift
//  Todoey
//
//  Created by Pham Minh Thuan on 11/06/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController,SwipeTableViewCellDelegate {
    
    //Tạo 1 th cell có hàn động swipe và dùng chung cho các th con bằng cách gọi super.method()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SwipeTableViewCell //muốn ép kiểu ở đây phải đổi tên class ở trong main.Storyboard
        cell.delegate=self
        return cell
        
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateDatasource(at: indexPath)
            }
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    func updateDatasource(at indexPath : IndexPath){
     //Tạo 1 rỗng ở đây để ghi đè ở th con
    }

}
