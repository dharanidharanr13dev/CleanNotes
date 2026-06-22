
import Foundation


extension String {
    func isoToFormatted(_ format: String = "dd MMM yyyy, h:mm a") -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        guard let date = isoFormatter.date(from: self) else {
            return self
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = .current
        outputFormatter.dateFormat = format

        return outputFormatter.string(from: date)
    }
}
