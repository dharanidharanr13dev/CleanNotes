
import Foundation


extension String {
    func toISO8601() -> String? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = formatter.date(from: self) {
            return formatter.string(from: date)
        }
        return nil
    }
    
    func isoToFormatted(_ format: String = "MMMM d, yyyy 'at' h:mm a") -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: self) else {
            return nil
        }
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale.current
        outputFormatter.dateFormat = format
        return outputFormatter.string(from: date)
    }
}
