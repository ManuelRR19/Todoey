//
//  Item.swift
//  Todoey
//
//  Created by Manuel on 4/25/19.
//  Copyright © 2019 ManuelRR. All rights reserved.
//

import Foundation

class Item : Codable {
    
    var title = ""
    var done : Bool = false
    
    init(task: String) {
        title = task
    }
    
}
