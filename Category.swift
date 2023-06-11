//
//  Data.swift
//  Todoey
//
//  Created by Pham Minh Thuan on 01/06/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @Persisted var name:String = ""
    @Persisted var items : List<Item>
}
