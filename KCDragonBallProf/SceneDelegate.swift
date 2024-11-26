import UIKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appState: AppState = AppState()
    var cancellable: AnyCancellable?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        appState.validateControlLogin()
        var nav : UINavigationController?
        
        self.cancellable = appState.$statusLogin
            .sink { estado in
                switch estado {
                case .notValidate, .none:
                    DispatchQueue.main.async {
                        print("login")
                        nav = UINavigationController(rootViewController: LoginViewController(appState: self.appState))
                        self.window!.rootViewController = nav
                        self.window!.makeKeyAndVisible()
                    }
                case .success:
                    DispatchQueue.main.async {
                        print("Vamos a la home")
                        nav = UINavigationController(rootViewController: HerosTableViewController(appState: self.appState, viewModel: HerosViewModel()))
                        self.window!.rootViewController = nav
                        self.window!.makeKeyAndVisible()
                    }
                case .error:
                    DispatchQueue.main.async {
                        print("Pantalla de error")
                        nav = UINavigationController(rootViewController: ErrorViewController(appState: self.appState, error: "Error en el login usuario/Clave"))
                        self.window!.rootViewController = nav
                        self.window!.makeKeyAndVisible()
                    }
                }
            }
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {

    }


}

