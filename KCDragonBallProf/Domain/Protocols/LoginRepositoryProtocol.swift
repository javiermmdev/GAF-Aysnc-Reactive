import Foundation

protocol LoginRepositoryProtocol {
    func loginApp(user: String, pasword: String) async -> String
}
