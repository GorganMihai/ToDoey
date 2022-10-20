//
//  Item.swift
//  ToDoey
//
//  Created by Mihai Gorgan on 20.10.2022.
//

import Foundation
import RealmSwift

class Item: Object {

    @objc dynamic var title : String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var backrounColor : String = ""
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")

}
