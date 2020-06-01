import Foundation

class ProductsManager {
    
    static let shared = ProductsManager()
    
    var products: [Product] = [] {
        didSet { NotificationsManager.shared.sheduleNotifications(for: products) }
    }
    
    func updateProducts(_ completion: @escaping ([Product]) -> Void) {
        API.Products.All().execute { response in
            defer { completion(self.products) }
            
            guard case .success(let result) = response else {
                self.products = []
                return
            }
            
            self.products = result.sorted(by: <)
        }
    }
    
    func saveProducts(_ products: [Product], _ completion: @escaping (Bool) -> Void) {
        self.products.append(contentsOf: products)
        
        API.Products.SaveArray(products: self.products).execute { response in
            switch response {
            case .success(_):
                completion(true)
            case .error(_, _):
                completion(false)
            }
        }
    }
    
    func createProduct(with barcode: String) -> Product {
        let product: Product
        
        if let template = TemplatesManager.shared.template(for: barcode) {
            product = Product(template: template)
        } else {
            product = Product(barcode: barcode)
        }
        
        return product
    }
    
    func synchronizeProduct(_ product: Product) {
        saveProducts([]) { _ in }
    }
    
    func removeProduct(_ product: Product,  _ completion: @escaping (Bool) -> Void) {
        products.removeAll { $0 == product }
        saveProducts([]) { success in completion(success) }
    }
    
}

class TemplatesManager {
    
    static let shared = TemplatesManager()
    
    var templates: [ProductTemplate] = []
    
    
    // MARK: - Templates.
    
    func template(for barcode: String) -> ProductTemplate? {
        templates.last { $0.barcode == barcode }
    }
    
    func updateTemplates() {
        API.Templates.All().execute { response in
            guard case .success(let result) = response else {
                return
            }
            
            self.templates = result
        }
    }
    
    func createTemplate(with product: Product, completion: @escaping (Bool) -> Void) {
        templates.removeAll { $0 == product }
        
        let template = ProductTemplate(product: product)
        
        templates.append(template)
        
        API.Templates.SaveArray(templates: templates).execute { response in
            switch response {
            case .success(_):
                completion(true)
            case .error(_):
                completion(false)
            }
        }
    }
    
}
