//
//  Category.swift
//  ToDoAppDemo2
//
//  Created by Supanut Laddayam on 27/3/2563 BE.
//  Copyright © 2563 Supanut Laddayam. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
