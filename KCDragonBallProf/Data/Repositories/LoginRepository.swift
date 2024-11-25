import Foundation

final class DefaultLoginRepository: LoginRepositoryProtocol {
    private var network: NetworkLoginProtocol
    
    init(network: NetworkLoginProtocol) {
        self.network = network
    }
    
    func loginApp(user: String, pasword: String) async -> String {
        return await network.loginApp(user: user, password: pasword)
    }
}

final class LoginRepositoryFake: LoginRepositoryProtocol {
    private var network: NetworkLoginProtocol
    
    init(network: NetworkLoginProtocol = NetworkLoginFake()) {
        self.network = network
    }
    
    func loginApp(user: String, pasword: String) async -> String {
        return await network.loginApp(user: user, password: pasword)
    }
}
