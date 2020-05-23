import Foundation

extension String {
    
    func date(format: Date.DateStringFormat = .general) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        
        return formatter.date(from: self)!
    }
    
}
