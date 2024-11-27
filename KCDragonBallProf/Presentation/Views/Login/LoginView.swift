import Foundation
import UIKit

class LoginView: UIView {
    
    public let logoImage = {
        let image = UIImageView(image: UIImage(named: "title"))
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    public let emailTextfield = {
        let textField = UITextField()
        textField.backgroundColor = .blue.withAlphaComponent(0.9)
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Email"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true //Para que se vea el borde redondeado
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        textField.placeholder = NSLocalizedString("Email", comment: "Email del usuario")
        return textField
    }()
    
    public let passwordTextfield = {
        let textField = UITextField()
        textField.backgroundColor = .blue.withAlphaComponent(0.9)
        textField.textColor = .white
        textField.font = .systemFont(ofSize: 18)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true //Para que se vea el borde redondeado
        textField.isSecureTextEntry = true // Convertirlo en un secureTextField
        textField.autocapitalizationType = .none // Evitar que la primera letra sea mayúscula
        textField.attributedPlaceholder = NSAttributedString(
            string: textField.placeholder!,
            attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray]
        )
        textField.placeholder = NSLocalizedString("Password", comment: "Password del usuario")
        return textField
    }()
    
    public let buttonLogin = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blue.withAlphaComponent(0.9)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.layer.cornerRadius = 29
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let backgroundImage = UIImage(named: "fondo3")!
        backgroundColor = UIColor(patternImage: backgroundImage)
        addSubview(logoImage)
        addSubview(emailTextfield)
        addSubview(passwordTextfield)
        addSubview(buttonLogin)
        
        NSLayoutConstraint.activate([
            //Logo
            logoImage.topAnchor.constraint(equalTo: topAnchor, constant: 120),
            logoImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            logoImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            logoImage.heightAnchor.constraint(equalToConstant: 70),
            
            //user
            emailTextfield.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 100),
            emailTextfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            emailTextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            emailTextfield.heightAnchor.constraint(equalToConstant: 50),
            
            //password
            passwordTextfield.topAnchor.constraint(equalTo: emailTextfield.bottomAnchor, constant: 25),
            passwordTextfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            passwordTextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            passwordTextfield.heightAnchor.constraint(equalToConstant: 50),
            
            //button login
            buttonLogin.topAnchor.constraint(equalTo: passwordTextfield.bottomAnchor, constant: 50),
            buttonLogin.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            buttonLogin.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            buttonLogin.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func getEmailView() -> UITextField {
        emailTextfield
    }
    
    func getPasswordView() -> UITextField {
        passwordTextfield
    }
    
    func getLogoImageView() -> UIImageView {
        logoImage
    }
    
    func getLoginButtonView() -> UIButton {
        buttonLogin
    }
}
