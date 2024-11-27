import Foundation
import UIKit

// Custom UIView class for the login screen
class LoginView: UIView {
    
    // UIImageView for displaying the app's logo
    public let logoImage = {
        let image = UIImageView(image: UIImage(named: "title")) // Loads an image named "title"
        image.translatesAutoresizingMaskIntoConstraints = false // Enables Auto Layout
        return image
    }()
    
    // UITextField for the user to input their email
    public let emailTextfield = {
        let textField = UITextField()
        textField.backgroundColor = .blue.withAlphaComponent(0.9) // Semi-transparent blue background
        textField.textColor = .white // White text color
        textField.font = .systemFont(ofSize: 18) // System font with size 18
        textField.translatesAutoresizingMaskIntoConstraints = false // Enables Auto Layout
        textField.placeholder = "Email" // Placeholder text
        textField.borderStyle = .roundedRect // Rounded rectangle border
        textField.layer.cornerRadius = 10 // Rounded corners with radius of 10
        textField.layer.masksToBounds = true // Ensures corners are properly masked
        textField.autocapitalizationType = .none // Prevents automatic capitalization
        textField.autocorrectionType = .no // Disables autocorrection
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder!, // Placeholder text
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray] // Gray placeholder color
        )
        textField.placeholder = NSLocalizedString("Email", comment: "Email del usuario") // Localized placeholder
        return textField
    }()
    
    // UITextField for the user to input their password
    public let passwordTextfield = {
        let textField = UITextField()
        textField.backgroundColor = .blue.withAlphaComponent(0.9) // Semi-transparent blue background
        textField.textColor = .white // White text color
        textField.font = .systemFont(ofSize: 18) // System font with size 18
        textField.translatesAutoresizingMaskIntoConstraints = false // Enables Auto Layout
        textField.placeholder = "Password" // Placeholder text
        textField.borderStyle = .roundedRect // Rounded rectangle border
        textField.layer.cornerRadius = 10 // Rounded corners with radius of 10
        textField.layer.masksToBounds = true // Ensures corners are properly masked
        textField.isSecureTextEntry = true // Hides text for password input
        textField.autocapitalizationType = .none // Prevents automatic capitalization
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder!, // Placeholder text
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray] // Gray placeholder color
        )
        textField.placeholder = NSLocalizedString("Password", comment: "Password del usuario") // Localized placeholder
        return textField
    }()
    
    // UIButton for submitting login credentials
    public let buttonLogin = {
        let button = UIButton(type: .system) // System button style
        button.setTitle("Login", for: .normal) // Button title
        button.backgroundColor = .blue.withAlphaComponent(0.9) // Semi-transparent blue background
        button.setTitleColor(.white, for: .normal) // White text color for normal state
        button.setTitleColor(.gray, for: .disabled) // Gray text color for disabled state
        button.layer.cornerRadius = 29 // Rounded corners with radius of 29
        button.translatesAutoresizingMaskIntoConstraints = false // Enables Auto Layout
        return button
    }()
    
    // Initializer for programmatically created instances
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews() // Set up the UI components
    }
    
    // Required initializer for using storyboards (not implemented here)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Method to configure and layout the UI components
    func setupViews() {
        let backgroundImage = UIImage(named: "fondo3")! // Load a background image
        backgroundColor = UIColor(patternImage: backgroundImage) // Set background with the pattern image
        addSubview(logoImage) // Add the logo image view to the view hierarchy
        addSubview(emailTextfield) // Add the email text field
        addSubview(passwordTextfield) // Add the password text field
        addSubview(buttonLogin) // Add the login button
        
        // Configure Auto Layout constraints for all components
        NSLayoutConstraint.activate([
            // Constraints for the logo image
            logoImage.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            logoImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            logoImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            logoImage.heightAnchor.constraint(equalToConstant: 70),
            
            // Constraints for the email text field
            emailTextfield.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 100),
            emailTextfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            emailTextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            emailTextfield.heightAnchor.constraint(equalToConstant: 50),
            
            // Constraints for the password text field
            passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 25),
            passwordTextfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            passwordTextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            passwordTextfield.heightAnchor.constraint(equalToConstant: 50),
            
            // Constraints for the login button
            buttonLogin.topAnchor.constraint(equalTo: passwordTextfield.bottomAnchor, constant: 50),
            buttonLogin.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            buttonLogin.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            buttonLogin.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    // Method to retrieve the email text field
    func getEmailView() -> UITextField {
        emailTextfield
    }
    
    // Method to retrieve the password text field
    func getPasswordView() -> UITextField {
        passwordTextfield
    }
    
    // Method to retrieve the logo image view
    func getLogoImageView() -> UIImageView {
        logoImage
    }
    
    // Method to retrieve the login button
    func getLoginButtonView() -> UIButton {
        buttonLogin
    }
}
