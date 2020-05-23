//
//  ProductTemplate.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 26/05/2019.
//  Copyright © 2019 Maxim Vitovitsky. All rights reserved.
//

import UIKit

class ProductTemplate: Codable {
    
    var name: String
    var barcode: String
    var storageDays: Day = 7
    
    init(product: Product) {
        let producationDate = product.productionDate.date()
        let shelfLifeEnd = product.shelfLifeEnd.date()
        let components = Calendar.current.dateComponents([.day], from: producationDate, to: shelfLifeEnd)
        
        name = product.name
        barcode = product.barcode
        storageDays = components.day!

    }

}

extension ProductTemplate: Equatable {
    
    static func == (lhs: ProductTemplate, rhs: ProductTemplate) -> Bool {
        lhs.barcode == rhs.barcode
    }
    
    static func == (lhs: ProductTemplate, rhs: Product) -> Bool {
        lhs.barcode == rhs.barcode
    }
    
    static func == (lhs: Product, rhs: ProductTemplate) -> Bool {
        lhs.barcode == rhs.barcode
    }
    
}
