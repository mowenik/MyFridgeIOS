import Alamofire

extension API {
    
    enum Templates {
        
        struct All: APIRequesting {
            
            var httpMethod: HTTPMethod { .get }
            var requestURL: String { "\(GroupManager.shared.groupID)/templates/.json" }
            var parameters: Any? { nil }
            
            typealias ResponseModel = [ProductTemplate]
            
        }
        
        struct SaveArray: APIRequesting {
            
            let templates: [ProductTemplate]
            
            var httpMethod: HTTPMethod { .patch }
            var requestURL: String { "\(GroupManager.shared.groupID)/.json" }
            var parameters: Any? {
                [ "templates": templates.map { $0.asDictionary() } ]
            }
            
            typealias ResponseModel = [String: [ProductTemplate]]
        }
        
    }
    
}
