//
//  Product.swift
//  MyFridge
//
//  Created by Maxim Vitovitsky on 17/05/2019.
//  Copyright © 2019 Maxim Vitovitsky. All rights reserved.
//

import Foundation
import RealmSwift

typealias Day = Int

class ProductImage: Object {
    @objc dynamic var imageID = ""
}

class Product: ObjectWithId {

    @objc dynamic var barcode: String = ""
    @objc dynamic var name: String = "Новый продукт"

    @objc dynamic var storageLife: StorageLife! = StorageLife()
    
    @objc dynamic var isSaved = false

}

extension Product {
    
    var productionDate: String {
        return storageLife.productionDate.string(.general)
    }
    
    var shelfLifeEnd: String {
        return storageLife.shelfLifeEnd.string(.general)
    }
    
    var savedImagesCount: Int {
        return ProductsManager.getImages(for: self).count
    }
    
    var images: [UIImage] {
        var savedImages = ProductsManager.getImages(for: self)
        
        if savedImages.count == 0 {
            if let barcodeImage = EAN13Generator.generateImage(fromNumber: barcode, size: CGSize(width: 800, height: 450)) {
                savedImages = [barcodeImage]
            }
        }
        
        return savedImages
    }
    
    func addImage(_ image: UIImage) {
        ProductsManager.saveImage(image, for: self)
    }
    
    func removeImage(_ image: ProductImage) { }
    
}
