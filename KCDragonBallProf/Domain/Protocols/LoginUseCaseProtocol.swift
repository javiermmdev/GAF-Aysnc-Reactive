import Foundation

protocol LoginUseCaseProtocol {
    var repo: LoginRepositoryProtocol { get set }
    func loginApp(user: String, password: String) async -> Bool
    func logout() async
    func validateToken() async -> Bool
}
