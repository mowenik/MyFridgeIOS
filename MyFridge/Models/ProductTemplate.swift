//
//  ProductTemplate.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 26/05/2019.
//  Copyright © 2019 Maxim Vitovitsky. All rights reserved.
//

import UIKit
import RealmSwift

class ProductTemplate: ObjectWithId {
    
    @objc dynamic var name: String = "Новый продукт"
    @objc dynamic var barcode: String = ""
    
    @objc dynamic var storageDays: Day = 7
    @objc dynamic var storageAfterOpening: Day = 3

}

