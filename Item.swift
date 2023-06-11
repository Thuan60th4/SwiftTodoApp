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
    @Persisted var title:String = ""
    @Persisted var done:Bool = false
    
    @Persisted(originProperty: "items") var parentCategory: LinkingObjects<Category>

}
