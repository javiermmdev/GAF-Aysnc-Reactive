import Foundation

// Protocol defining the contract for the network layer responsible for login
protocol NetworkLoginProtocol {
    // Function to perform the login request
    // Parameters:
    // - user: The username or email provided by the user
    // - password: The password provided by the user
    // Returns: A `String` representing the token received upon successful login
    func loginApp(user: String, password: String) async -> String
}

// Implementation of the NetworkLogin protocol for real network requests
final class NetworkLogin: NetworkLoginProtocol {
    // Function to perform the login request and return a JWT token
    func loginApp(user: String, password: String) async -> String {
        var tokenJWT: String = "" // Token to be returned upon successful login
        
        // Construct the URL string for the login endpoint
        let urlString: String = "\(ConstantsApp.CONST_API_URL)\(EndPoints.login.rawValue)"
        
        // Encode the user's credentials in Base64 for Basic Authorization
        let encodeCredentials = "\(user):\(password)".data(using: .utf8)?.base64EncodedString()
        var segCredential: String = ""
        if let credentials = encodeCredentials {
            segCredential = "Basic \(credentials)" // Prefix with "Basic"
        }
        
        // Create and configure the URLRequest for the login API
        var request: URLRequest = URLRequest(url: URL(string: urlString)!)
        request.httpMethod = HTTPMethods.post // HTTP POST method
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-type") // JSON content type
        request.addValue(segCredential, forHTTPHeaderField: "Authorization") // Authorization header
        
        // Perform the network request using `URLSession`
        do {
            let (data, response) = try await URLSession.shared.data(for: request) // Asynchronous request
            if let resp = response as? HTTPURLResponse,
               resp.statusCode == HTTPResponseCodes.SUCCESS { // Check if the status code indicates success
                tokenJWT = String(decoding: data, as: UTF8.self) // Decode the token from response data
            }
        } catch {
            tokenJWT = "" // Return an empty token if an error occurs
        }
        
        return tokenJWT // Return the received token (or empty string in case of failure)
    }
}

// Fake implementation of the NetworkLogin protocol for testing
final class NetworkLoginFake: NetworkLoginProtocol {
    // Function to simulate the login request
    // Parameters:
    // - user: The username or email provided by the user (not used in the fake implementation)
    // - password: The password provided by the user (not used in the fake implementation)
    // Returns: A randomly generated UUID string simulating a token
    func loginApp(user: String, password: String) async -> String {
        return UUID().uuidString // Generate and return a unique token
    }
}
