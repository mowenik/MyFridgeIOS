import Foundation

extension Date {
    
    func byAddingDays(_ days: Day) -> Date {
        var dateComponents = DateComponents()
        dateComponents.day = days
        
        let calendar = Calendar.current
        return calendar.date(byAdding: dateComponents, to: self) ?? self
    }
    
    func difference(to date: Date) -> Day {
        let calendar = Calendar.current
        
        let start = calendar.startOfDay(for: self)
        let end = calendar.startOfDay(for: date)
        
        let days = calendar.dateComponents([.day], from: start, to: end).day ?? 1
        
        return Day(days)
    }
    
}

extension Date {
    
    enum DateStringFormat: String {
        case general = "dd.MM.yy"
    }
    
    func string(_ format: DateStringFormat) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        
        return formatter.string(from: self)
    }
    
}
