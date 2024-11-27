import Foundation

// Protocol defining the contract for login operations
protocol LoginRepositoryProtocol {
    // Asynchronous function for user login
    // Parameters:
    // - user: The username or email entered by the user
    // - pasword: The password entered by the user (note: there is a typo in "pasword")
    // Returns: A `String` which could represent a token, status message, or error
    func loginApp(user: String, pasword: String) async -> String
}
