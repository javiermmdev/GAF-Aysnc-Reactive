import Foundation
import KcLibraryswift

// Concrete implementation of the Login Use Case
final class LoginUseCase: LoginUseCaseProtocol {
    // Dependency for the repository responsible for login-related operations
    var repo: LoginRepositoryProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - repo: The repository implementation, defaulting to `DefaultLoginRepository`
    init(repo: LoginRepositoryProtocol = DefaultLoginRepository(network: NetworkLogin())) {
        self.repo = repo
    }

    // Function to handle user login
    // Parameters:
    // - user: The username or email provided by the user
    // - password: The password provided by the user
    // Returns: A Boolean indicating whether the login was successful
    func loginApp(user: String, password: String) async -> Bool {
        // Calls the repository's login method and retrieves a token
        let token = await repo.loginApp(user: user, pasword: password)
        
        if token != "" { // Checks if the token is non-empty (successful login)
            // Saves the token in the Keychain for persistent storage
            KeyChainKC().saveKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN, value: token)
            return true
        } else { // Handles the login failure case
            // Deletes any existing token from the Keychain
            KeyChainKC().deleteKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
            return false
        }
    }
    
    // Function to handle user logout
    // Deletes the token from the Keychain
    func logout() async {
        KeyChainKC().deleteKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
    }
    
    // Function to validate the current token
    // Returns: A Boolean indicating whether the token is valid
    func validateToken() async -> Bool {
        // Loads the token from the Keychain and checks if it's non-empty
        if KeyChainKC().loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN) != "" {
            return true
        } else {
            return false
        }
    }
}

// Fake implementation of the Login Use Case for testing
final class LoginUseCaseFake: LoginUseCaseProtocol {
    // Dependency for the repository responsible for login operations
    var repo: LoginRepositoryProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - repo: The repository implementation, defaulting to `DefaultLoginRepository`
    init(repo: LoginRepositoryProtocol = DefaultLoginRepository(network: NetworkLogin())) {
        self.repo = repo
    }

    // Function to simulate user login
    // Parameters:
    // - user: The username or email (not used in the fake implementation)
    // - password: The password (not used in the fake implementation)
    // Returns: Always simulates a successful login
    func loginApp(user: String, password: String) async -> Bool {
        // Saves a fake token to the Keychain to simulate a successful login
        KeyChainKC().saveKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN, value: "LoginFakeSuccess")
        return true
    }
    
    // Function to simulate user logout
    // Deletes the fake token from the Keychain
    func logout() async {
        KeyChainKC().deleteKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
    }
    
    // Function to simulate token validation
    // Always returns true to indicate a valid token
    func validateToken() async -> Bool {
        return true
    }
}
