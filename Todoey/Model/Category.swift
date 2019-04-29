//
//  Category.swift
//  Todoey
//
//  Created by Manuel on 4/27/19.
//  Copyright © 2019 ManuelRR. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
