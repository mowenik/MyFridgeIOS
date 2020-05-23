import Alamofire

extension API {
    
    enum Products {
        
        struct All: APIRequesting {
            
            var httpMethod: HTTPMethod { .get }
            var requestURL: String { "\(GroupManager.shared.groupID)/products/.json" }
            var parameters: Any? { nil }
            
            typealias ResponseModel = [Product]
            
        }
        
        struct SaveArray: APIRequesting {
            
            let products: [Product]
            
            var httpMethod: HTTPMethod { .patch }
            var requestURL: String { "\(GroupManager.shared.groupID)/.json" }
            var parameters: Any? {
                [ "products": products.map { $0.asDictionary() } ]
            }
            
            typealias ResponseModel = [String: [Product]]
            
        }
        
    }
    
}
