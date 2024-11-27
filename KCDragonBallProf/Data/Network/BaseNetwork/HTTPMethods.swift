import Foundation

// Struct to define common HTTP methods and related content types
struct HTTPMethods {
    // HTTP method for sending data to the server (e.g., for creating resources)
    static let post = "POST"
    
    // HTTP method for retrieving data from the server
    static let get = "GET"
    
    // HTTP method for updating existing resources on the server
    static let put = "PUT"
    
    // HTTP method for deleting resources from the server
    static let delete = "DELETE"
    
    // Content type for specifying JSON data in request headers
    static let content = "application/json"
}
