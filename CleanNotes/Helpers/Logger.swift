
import Foundation


struct Logger {
    static func debug(_ message: String) {
        #if DEBUG
        print(message)
        #else
        
        #endif
    }
}
