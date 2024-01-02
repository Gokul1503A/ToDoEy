//
//  Catagory.swift
//  Todoey
//
//  Created by KOPPOLA GOKUL SAI on 28/12/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Catagory:Object{
    @objc dynamic var name: String = ""
    @objc dynamic var Colour: String = ""
    let items = List<Item>()
}
