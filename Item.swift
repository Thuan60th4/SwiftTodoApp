//
//  Item.swift
//  Todoey
//
//  Created by Pham Minh Thuan on 01/06/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item :Object{
   @objc dynamic var title:String = ""
    @objc dynamic var done:Bool = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
