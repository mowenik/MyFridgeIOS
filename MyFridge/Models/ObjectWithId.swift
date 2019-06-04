import Foundation
import RealmSwift

class ObjectWithId: Object {
    
    @objc dynamic var id: String = UUID().uuidString
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
