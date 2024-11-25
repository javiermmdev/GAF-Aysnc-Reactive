import UIKit
import Foundation
import Combine
import CombineCocoa

final class LoginViewController: UIViewController {
    private var appState: AppState?
    var logo: UIImageView?
    var loginButton: UIButton?
    var emailTextfield: UITextField?
    var passwordTextfield: UITextField?
    private var user: String = ""
    private var pass: String = ""
    private var subscriptions = Set<AnyCancellable>()
    
    
    init(appState: AppState) {
        self.appState = appState
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindingUI()
    }
    
    override func loadView() {
        let loginView = LoginView()
        logo = loginView.getLogoImageView()
        emailTextfield = loginView.getEmailView()
        passwordTextfield = loginView.getPasswordView()
        loginButton = loginView.getLoginButtonView()
        view = loginView
    }
    
    func bindingUI() {
        if let emailTextfield = self.emailTextfield {
            emailTextfield.textPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] data in
                    if let usr = data {
                        print("Text user: \(usr)")
                        self?.user = usr
                        
                        if let button = self?.loginButton {
                            if (self?.user.count)! > 5 {
                                button.isEnabled = true
                            } else {
                                button.isEnabled = false
                            }
                        }
                    }
                })
                .store(in: &subscriptions)
        }
        
        if let passwordTextfield = self.passwordTextfield {
            passwordTextfield.textPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] data in
                    if let pass = data {
                        print("Text pass: \(pass)")
                        self?.pass = pass
                    }
                })
                .store(in: &subscriptions)
        }

        
        if let button = self.loginButton {
            button.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] _ in
                    if let user = self?.user,
                       let pass = self?.pass {
                        self?.appState?.loginApp(user: user, pass: pass)
                    }
                }).store(in: &subscriptions)
        }
    }
}

#Preview {
    LoginViewController(appState: AppState())
}
