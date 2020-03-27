//
//  Item.swift
//  ToDoAppDemo2
//
//  Created by Supanut Laddayam on 27/3/2563 BE.
//  Copyright © 2563 Supanut Laddayam. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
