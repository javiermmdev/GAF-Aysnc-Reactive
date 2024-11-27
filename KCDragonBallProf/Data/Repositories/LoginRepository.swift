import Foundation

// Concrete implementation of the Login Repository
final class DefaultLoginRepository: LoginRepositoryProtocol {
    // Dependency for the network layer that handles login-related network operations
    private var network: NetworkLoginProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - network: The network layer implementation, typically handling real network requests
    init(network: NetworkLoginProtocol) {
        self.network = network
    }
    
    // Function to handle the login process
    // Parameters:
    // - user: The username or email provided by the user
    // - pasword: The password provided by the user (note: "pasword" appears to be a typo and should be "password")
    // Returns: A `String` representing the login token or an error message
    func loginApp(user: String, pasword: String) async -> String {
        // Delegates the login process to the network layer
        return await network.loginApp(user: user, password: pasword)
    }
}

// Fake implementation of the Login Repository for testing
final class LoginRepositoryFake: LoginRepositoryProtocol {
    // Dependency for the fake network layer that simulates login-related operations
    private var network: NetworkLoginProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - network: The fake network layer implementation, defaulting to `NetworkLoginFake`
    init(network: NetworkLoginProtocol = NetworkLoginFake()) {
        self.network = network
    }
    
    // Function to simulate the login process
    // Parameters:
    // - user: The username or email provided by the user (simulated, not used in logic)
    // - pasword: The password provided by the user (simulated, not used in logic)
    // Returns: A `String` simulating a login token or a predefined response
    func loginApp(user: String, pasword: String) async -> String {
        // Delegates the login process to the fake network layer
        return await network.loginApp(user: user, password: pasword)
    }
}
