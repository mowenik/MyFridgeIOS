//
//  StorageLife.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 19/05/2019.
//  Copyright © 2019 Maxim Vitovitsky. All rights reserved.
//

import Foundation
import RealmSwift

@objc
class StorageLife: Object {
    
    @objc dynamic var productionDate: Date = Date()
    @objc dynamic var shelfLifeEnd = Date().byAddingDays(7)
    
    @objc dynamic var openingDate: Date?
    @objc dynamic var storageAfterOpening: Day = 3 
    
}


