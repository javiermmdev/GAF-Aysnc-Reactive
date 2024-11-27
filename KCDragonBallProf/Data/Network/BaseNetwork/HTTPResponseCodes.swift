import Foundation

// Struct to define commonly used HTTP response codes
struct HTTPResponseCodes {
    // Success: Indicates the request was successful and the server responded with the requested data
    static let SUCCESS = 200
    
    // Bad Request: Indicates the request was malformed or contains invalid parameters
    static let BAD_REQUEST = 400
    
    // Not Authorized: Indicates the request lacks valid authentication credentials
    static let NOT_AUTHORIZED = 401
    
    // Error: Indicates a server error, such as a bad gateway or server overload
    static let ERROR = 502
}
