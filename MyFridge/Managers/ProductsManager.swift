import RealmSwift

class ProductsManager {
    
    static var realm: Realm {
        return try! Realm()
    }
    
    // MARK: Get products
    
    static func getSavedProducts() -> [Product] {
        return getProducts(isSaved: true)
    }
    
    static func getUnsavedProducts() -> [Product] {
        return getProducts(isSaved: false)
    }
    
    static private func getProducts(isSaved: Bool) -> [Product] {
        let results = realm.objects(Product.self).filter("isSaved == \(isSaved)")
        return Array(results)
    }
    
    // MARK: Get templates
    
    static func getTemplates() -> [ProductTemplate] {
        let results = realm.objects(ProductTemplate.self)
        return Array(results)
    }
    
    static func getTemplate(for barcode: String) -> ProductTemplate? {
        let allTemplates = getTemplates()
        return allTemplates.first { template in
            return template.barcode == barcode
        }
    }
    
    // MARK: Create
    
    static func createProduct(with barcode: String = "") -> Product {
        let product = Product()
        product.barcode = barcode
        
        if let template = getTemplate(for: barcode) {
            product.name = template.name
            product.storageLife.productionDate = Date()
            product.storageLife.shelfLifeEnd = Date().byAddingDays(template.storageDays)
            product.storageLife.storageAfterOpening = template.storageAfterOpening
        }
        
        try! realm.write {
            realm.add(product)
        }
        
        return product
    }
    
    static func createTemplate(with product: Product) {
        let template = ProductTemplate()
        let storage = product.storageLife!
        let storageDays = storage.productionDate.difference(to: storage.shelfLifeEnd)
        
        template.name = product.name
        template.barcode = product.barcode
        template.storageDays = storageDays
        template.storageAfterOpening = storage.storageAfterOpening
        
        try! realm.write {
            realm.add(template)
        }
    }
    
    // MARK: Edit
    
    static func setName(_ name: String, for product: Product) {
        try! realm.write {
            product.name = name
        }
    }
    
    static func setProductionDate(_ date: Date, for product: Product) {
        if date > product.storageLife.shelfLifeEnd {
            return
        }
        
        let storageDays = product.storageLife.productionDate.difference(to: product.storageLife.shelfLifeEnd)
        
        try! realm.write {
            product.storageLife.productionDate = date
        }

        setShelfLifeEndDate(date.byAddingDays(storageDays), for: product)
        updateDaysAfterOpening(for: product)
    }
    
    static func setShelfLifeEndDate(_ date: Date, for product: Product) {
        if date < product.storageLife.productionDate {
            return
        }
        
        try! realm.write {
            product.storageLife.shelfLifeEnd = date
        }
        
        updateDaysAfterOpening(for: product)
    }
    
    static func updateDaysAfterOpening(for product: Product) {
        let production = product.storageLife.productionDate
        let shelfLifeEnd = product.storageLife.shelfLifeEnd
        let difference = production.difference(to: shelfLifeEnd)
        
        if difference > product.storageLife.storageAfterOpening {
            try! realm.write {
                product.storageLife.storageAfterOpening = difference
            }
        }
    }
    
    static func saveProducts(_ products: [Product]) {
        try! realm.write {
            for product in products {
                product.isSaved = true
            }
        }
    }
    
    // MARK: Remove
    
    static func remove(_ product: Product) {
        try! realm.write {
            realm.delete(product)
        }
    }
    
    // MARK: Images
    
    static func getImages(for product: Product) -> [UIImage] {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let directory = documents.first else {
            return [UIImage]()
        }
        
        var images = [UIImage]()
        
        do {
            let productFolder = directory.appendingPathComponent(product.barcode)
            let imagesURLs = try fileManager.contentsOfDirectory(at: productFolder, includingPropertiesForKeys: nil)
            
            for imageURL in imagesURLs {
                if let image = UIImage(contentsOfFile: imageURL.path) {
                    images.append(image)
                }
            }
        } catch {
            print("Error getting image:", error)
        }
        
        return images
    }
    
    static func saveImage(_ image: UIImage, for product: Product) {
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let productFolder = documents.appendingPathComponent(product.barcode)
        
        if !fileManager.fileExists(atPath: productFolder.path) {
            try? fileManager.createDirectory(at: productFolder, withIntermediateDirectories: false, attributes: nil)
        }
        
        let imageName = "\(product.images.count).jpg"
        let fileURL = productFolder.appendingPathComponent(imageName)
        let imageData = image.jpegData(compressionQuality:  1.0)
        let isExists = FileManager.default.fileExists(atPath: fileURL.path)
        
        if let data = imageData, !isExists {
            do {
                try data.write(to: fileURL)
                print("Image saved")
            } catch {
                print("Error saving image:", error)
            }
        }
    }
    
}
