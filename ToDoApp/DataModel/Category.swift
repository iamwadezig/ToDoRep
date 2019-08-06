//
//  Category.swift
//  ToDoApp
//
//  Created by Ario Nugroho on 02/08/19.
//  Copyright © 2019 Ario Nugroho. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    // realm mengharuskan tambahan @obj dynamic pada variabel kelas agar menjadi properti karena variabel realm bersifat dinamic
    
    @objc dynamic var name : String = ""
    
    // konek dengan class item *
    let items = List<Item>()
    
}
