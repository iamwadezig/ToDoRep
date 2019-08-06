//
//  Item.swift
//  ToDoApp
//
//  Created by Ario Nugroho on 02/08/19.
//  Copyright © 2019 Ario Nugroho. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    
    // realm mengharuskan tambahan @obj dynamic pada variabel kelas agar menjadi properti karena variabel realm bersifat dinamic
    
    
    @objc dynamic var title : String = ""
    
    @objc dynamic var done : Bool = false
    
    @objc dynamic var dateCreated : Date?
    
    // konek dengan class category *
    var parenCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
