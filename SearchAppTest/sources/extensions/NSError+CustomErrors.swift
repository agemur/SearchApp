

import Foundation


extension NSError {
    static var undefinedServerError = NSError(
           domain: "Undefined server error",
           code: 100,
           userInfo: [ NSLocalizedDescriptionKey: "Undefined server error"])
    static var internalServerError = NSError(
        domain: "Server error",
        code: 101,
        userInfo: [ NSLocalizedDescriptionKey: "Server error"])
    static var serverDataError = NSError(
        domain: "Server data error",
        code: 102,
        userInfo: [ NSLocalizedDescriptionKey: "Server data error"])
}
