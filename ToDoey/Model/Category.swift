//
//  Category.swift
//  ToDoey
//
//  Created by Mihai Gorgan on 20.10.2022.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var backrounColor : String = ""
    
    let items = List<Item>()
    
}
