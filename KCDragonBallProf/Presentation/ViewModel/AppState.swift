import Foundation

// Enum to represent the login status of the user
enum LoginStatus {
    case none          // No login attempt has been made
    case success       // Login was successful
    case error         // Login failed
    case notValidate   // Token validation failed
}

// Main application state class
final class AppState {
    // Published property to notify observers about login status changes
    @Published var statusLogin: LoginStatus = .none
    
    // Dependency for handling login operations
    private var loginUseCase: LoginUseCaseProtocol
    
    // Initializer to inject dependencies; uses a default implementation of LoginUseCaseProtocol
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    // Function to handle the login process
    // Parameters:
    // - user: The username input
    // - pass: The password input
    func loginApp(user: String, pass: String) {
        Task {
            // Calls the login method from the use case; updates the status based on the result
            if (await loginUseCase.loginApp(user: user, password: pass)) {
                self.statusLogin = .success  // Login successful
            } else {
                self.statusLogin = .error   // Login failed
            }
        }
    }
    
    // Function to validate the login token
    func validateControlLogin() {
        Task {
            // Calls the validateToken method; updates the status based on the result
            if (await loginUseCase.validateToken()) {
                self.statusLogin = .success      // Token is valid
            } else {
                self.statusLogin = .notValidate // Token is invalid
            }
        }
    }
    
    // Function to log out the user
    func closeSessionUser() {
        Task {
            // Calls the logout method and resets the login status to none
            await loginUseCase.logout()
            self.statusLogin = .none
        }
    }
}
