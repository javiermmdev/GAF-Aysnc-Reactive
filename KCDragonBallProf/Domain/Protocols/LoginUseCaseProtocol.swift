import Foundation

// Protocol defining the contract for the Login Use Case
protocol LoginUseCaseProtocol {
    // A property representing the repository for login operations
    var repo: LoginRepositoryProtocol { get set }
    
    // Function to handle user login
    // Parameters:
    // - user: The username or email provided by the user
    // - password: The password provided by the user
    // Returns: A Boolean indicating whether the login was successful
    func loginApp(user: String, password: String) async -> Bool
    
    // Function to handle user logout
    // This function does not return any value and is performed asynchronously
    func logout() async
    
    // Function to validate the current session token
    // Returns: A Boolean indicating whether the token is valid
    func validateToken() async -> Bool
}
