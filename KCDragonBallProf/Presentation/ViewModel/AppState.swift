import Foundation

enum LoginStatus {
    case none
    case success
    case error
    case notValidate
}

final class AppState {
    @Published var statusLogin: LoginStatus = .none
    private var loginUseCase: LoginUseCaseProtocol
    
    init(loginUseCase: LoginUseCaseProtocol = LoginUseCase()) {
        self.loginUseCase = loginUseCase
    }
    
    func loginApp(user: String, pass: String) {
        Task {
            if (await loginUseCase.loginApp(user: user, password: pass)) {
                self.statusLogin = .success
            } else {
                self.statusLogin = .error
            }
        }
    }
    
    func validateControlLogin() {
        Task {
            if (await loginUseCase.validateToken()) {
                self.statusLogin = .success
            } else {
                self.statusLogin = .notValidate
            }
        }
    }
    
    func closeSessionUser() {
        Task {
            await loginUseCase.logout()
            self.statusLogin = .none
        }
    }
}
