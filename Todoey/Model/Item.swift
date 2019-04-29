//
//  Item.swift
//  Todoey
//
//  Created by Manuel on 4/27/19.
//  Copyright © 2019 ManuelRR. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
