//
//  Item.swift
//  Todoey
//
//  Created by KOPPOLA GOKUL SAI on 28/12/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCatagory = LinkingObjects(fromType: Catagory.self, property: "items")
}
