//
//  Product.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 17/05/2019.
//  Copyright © 2019 Maxim Vitovitsky. All rights reserved.
//

import Foundation
import UIKit

typealias Day = Int

class Product: Codable {
    
    var id: String { "\(barcode)_\(timestamp)" }
    
    var barcode: String
    var timestamp: Int
    var name: String
    var productionDate: String
    var shelfLifeEnd: String
    
    init(barcode: String) {
        let date = Date()
        
        self.barcode = barcode
        self.timestamp = Int(date.timeIntervalSince1970)
        self.name = "# Новый продукт"
        self.productionDate = date.string(.general)
        self.shelfLifeEnd = date.byAddingDays(3).string(.general)
    }
    
    init(template: ProductTemplate) {
        let date = Date()
        
        self.barcode = template.barcode
        self.timestamp = Int(date.timeIntervalSince1970)
        self.name = template.name
        self.productionDate = date.string(.general)
        self.shelfLifeEnd = date.byAddingDays(template.storageDays).string(.general)
    }
    
}

extension Product: Comparable {
    
    static func < (lhs: Product, rhs: Product) -> Bool {
        lhs.timestamp < rhs.timestamp
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.barcode == rhs.barcode && lhs.timestamp == rhs.timestamp
    }
    
}

extension Product {
    
    func addImage(_ image: UIImage, completion: @escaping (Bool) -> Void) {
        FirebaseStorage.shared.saveImage(image, for: self, completion: completion)
    }
    
    func getImage(completion: @escaping (UIImage?) -> Void) {
        FirebaseStorage.shared.getImage(for: self, completion: completion)
    }
    
    func setName(_ name: String) {
        self.name = name
        ProductsManager.shared.synchronizeProduct(self)
    }
    
    func setProductionDate(_ date: Date) {
        productionDate = date.string(.general)
        
        if date > shelfLifeEnd.date() {
            shelfLifeEnd = date.byAddingDays(1).string(.general)
        }
        
        if let template = TemplatesManager.shared.template(for: self.barcode) {
            shelfLifeEnd = date.byAddingDays(template.storageDays).string(.general)
        }
        
        ProductsManager.shared.synchronizeProduct(self)
    }
    
    func setShelfLifeEndDate(_ date: Date) {
        shelfLifeEnd = date.string(.general)
        
        if date < productionDate.date() {
            if let template = TemplatesManager.shared.template(for: self.barcode) {
                productionDate = date.byAddingDays(-template.storageDays).string(.general)
            } else {
                productionDate = date.byAddingDays(-1).string(.general)
            }
        }
        
        ProductsManager.shared.synchronizeProduct(self)
    }
    
}

extension Encodable {
    
    func asDictionary() -> [String : Any] {
        let data = try! JSONEncoder().encode(self)
        return try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
    }
    
}
