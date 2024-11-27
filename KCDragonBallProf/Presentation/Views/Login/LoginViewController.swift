import UIKit
import Foundation
import Combine
import CombineCocoa

// ViewController for handling user login functionality
final class LoginViewController: UIViewController {

    // AppState for managing application-wide state and interactions
    private var appState: AppState?
    // UI components for the login screen
    var logo: UIImageView? // ImageView for displaying the app's logo
    var loginButton: UIButton? // Button for submitting login credentials
    var emailTextfield: UITextField? // TextField for user to input their email
    var passwordTextfield: UITextField? // TextField for user to input their password
    // Strings to hold user input
    private var user: String = "" // Stores the entered email or username
    private var pass: String = "" // Stores the entered password
    // Set to store Combine subscriptions for reactive bindings
    private var subscriptions = Set<AnyCancellable>()

    // Custom initializer with dependency injection for AppState
    // Parameters:
    // - appState: The global application state used for managing user authentication
    init(appState: AppState) {
        self.appState = appState
        super.init(nibName: nil, bundle: nil)
    }
    
    // Required initializer for using storyboards (not implemented here)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Lifecycle method called after the view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        bindingUI() // Set up reactive bindings for the UI
    }
    
    // Method to load the custom login view
    override func loadView() {
        let loginView = LoginView()
        // Fetch UI components from the custom view
        logo = loginView.getLogoImageView()
        emailTextfield = loginView.getEmailView()
        passwordTextfield = loginView.getPasswordView()
        loginButton = loginView.getLoginButtonView()
        view = loginView // Set the custom view as the controller's main view
    }
    
    // Function to set up reactive bindings between UI elements and logic
    func bindingUI() {
        // Bind the email text field input to the `user` property
        if let emailTextfield = self.emailTextfield {
            emailTextfield.textPublisher
                .receive(on: DispatchQueue.main) // Ensure updates occur on the main thread
                .sink(receiveValue: { [weak self] data in
                    if let usr = data {
                        print("Text user: \(usr)") // Debug log for user input
                        self?.user = usr
                        
                        // Enable or disable the login button based on input length
                        if let button = self?.loginButton {
                            if (self?.user.count)! > 5 {
                                button.isEnabled = true
                            } else {
                                button.isEnabled = false
                            }
                        }
                    }
                })
                .store(in: &subscriptions) // Store the subscription
        }
        
        // Bind the password text field input to the `pass` property
        if let passwordTextfield = self.passwordTextfield {
            passwordTextfield.textPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] data in
                    if let pass = data {
                        print("Text pass: \(pass)") // Debug log for password input
                        self?.pass = pass
                    }
                })
                .store(in: &subscriptions)
        }

        // Bind the login button tap action to the login process
        if let button = self.loginButton {
            button.tapPublisher
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] _ in
                    // Trigger login via AppState using the entered credentials
                    if let user = self?.user,
                       let pass = self?.pass {
                        self?.appState?.loginApp(user: user, pass: pass)
                    }
                }).store(in: &subscriptions)
        }
    }
}

#Preview {
    LoginViewController(appState: AppState()) // Preview with an instance of AppState
}
