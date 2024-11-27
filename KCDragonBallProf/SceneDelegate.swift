import UIKit
import Combine

// The SceneDelegate class manages the app's scenes, including the main UIWindow
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    // The main window of the app
    var window: UIWindow?
    // AppState instance to manage application-wide state
    var appState: AppState = AppState()
    // Combine cancellable for observing statusLogin changes
    var cancellable: AnyCancellable?

    // This method is called when the scene connects to the app
    // Parameters:
    // - scene: The scene object
    // - session: The session associated with the scene
    // - connectionOptions: Configuration options for connecting the scene
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Ensure the scene is a UIWindowScene
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene) // Initialize the main window

        // Validate login state using AppState
        appState.validateControlLogin()
        var nav: UINavigationController? // Navigation controller for managing view transitions

        // Observe changes to the app's login status
        self.cancellable = appState.$statusLogin
            .sink { estado in
                switch estado {
                case .notValidate, .none: // If login is invalid or not attempted
                    DispatchQueue.main.async {
                        print("login") // Debug message
                        // Show the login screen
                        nav = UINavigationController(rootViewController: LoginViewController(appState: self.appState))
                        self.window!.rootViewController = nav
                        self.window!.makeKeyAndVisible() // Make the window visible
                    }
                case .success: // If login is successful
                    DispatchQueue.main.async {
                        print("Vamos a la home") // Debug message
                        // Show the main heroes list screen
                        nav = UINavigationController(rootViewController: HerosTableViewController(appState: self.appState, viewModel: HerosViewModel()))
                        self.window!.rootViewController = nav
                        self.window!.makeKeyAndVisible() // Make the window visible
                    }
                case .error: // If there is a login error
                    DispatchQueue.main.async {
                        print("Pantalla de error") // Debug message
                        // Show the error screen
                        nav = UINavigationController(rootViewController: ErrorViewController(appState: self.appState, error: "Error en el login usuario/Clave"))
                        self.window!.rootViewController = nav
                        self.window!.makeKeyAndVisible() // Make the window visible
                    }
                }
            }
    }

    // Called when the scene is disconnected
    func sceneDidDisconnect(_ scene: UIScene) {
        // Clean-up tasks when the scene is disconnected
    }

    // Called when the scene becomes active
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Handle tasks to resume activity
    }

    // Called when the scene is about to resign activity
    func sceneWillResignActive(_ scene: UIScene) {
        // Handle tasks to pause or save state
    }

    // Called when the scene enters the foreground
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Handle tasks to prepare the app for user interaction
    }

    // Called when the scene enters the background
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Handle tasks to save data or release resources
    }
}
