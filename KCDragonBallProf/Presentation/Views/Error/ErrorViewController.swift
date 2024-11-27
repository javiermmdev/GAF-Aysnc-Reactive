import UIKit
import Combine
import CombineCocoa

// ViewController for displaying error messages and allowing the user to return to the home screen
class ErrorViewController: UIViewController {
    
    // AppState to manage and update the application's global state
    private var appState: AppState?
    // Set to store Combine subscriptions for reactive updates
    private var suscriptor = Set<AnyCancellable>()
    // Variable to store the error message to be displayed
    private var error: String?
    
    // IBOutlet connected to the UILabel that displays the error message
    @IBOutlet weak var labelError: UILabel!
    // IBOutlet connected to the UIButton that navigates back to the home screen
    @IBOutlet weak var backButton: UIButton!
    
    // Custom initializer with dependency injection
    // Parameters:
    // - appState: The application state to be updated when navigating back
    // - error: The error message to be displayed on the screen
    internal init(appState: AppState,
                  error: String) {
        self.appState = appState
        self.error = error
        super.init(nibName: nil, bundle: nil) // Calls the superclass initializer
    }
    
    // Required initializer for using storyboards (not implemented here)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // Ensures this class is not initialized via storyboard
    }
    
    // Lifecycle method called after the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the error message on the UILabel
        self.labelError.text = self.error
        
        // Set the title of the back button
        self.backButton.setTitle(
            NSLocalizedString("Home", comment: "Title of the button to return to the home screen"),
            for: .normal
        )
        
        // Reactively handle taps on the back button
        self.backButton.tapPublisher
            .sink {
                self.appState?.statusLogin = .none // Update the login status to none
            }
            .store(in: &suscriptor) // Store the subscription
    }
}
