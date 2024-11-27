import Combine
import CombineCocoa
import KcLibraryswift
import UIKit
import XCTest

@testable import KCDragonBallProf

final class KCDragonBallProfTests: XCTestCase {
    
    private var subscriptions = Set<AnyCancellable>()


    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testKeyChainLibrary() throws {
        let KC = KeyChainKC()
        XCTAssertNotNil(KC)

        let save = KC.saveKC(key: "Test", value: "123")
        XCTAssertEqual(save, true)

        let value = KC.loadKC(key: "Test")
        if let valor = value {
            XCTAssertEqual(valor, "123")
        }
        XCTAssertNoThrow(KC.deleteKC(key: "Test"))
    }

    func testLoginFake() async throws {
        let KC = KeyChainKC()
        XCTAssertNotNil(KC)

        let obj = LoginUseCaseFake()
        XCTAssertNotNil(obj)

        //Validate Token
        let resp = await obj.validateToken()
        XCTAssertEqual(resp, true)

        // login
        let loginDo = await obj.loginApp(user: "", password: "")
        XCTAssertEqual(loginDo, true)
        var jwt = KC.loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertNotEqual(jwt, "")

        //Close Session
        await obj.logout()
        jwt = KC.loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertEqual(jwt, "")
    }

    func testLoginReal() async throws {
        let CK = KeyChainKC()
        XCTAssertNotNil(CK)
        //reset the token
        CK.saveKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN, value: "")

        //Caso se uso con repo Fake
        let userCase = LoginUseCase(repo: LoginRepositoryFake())
        XCTAssertNotNil(userCase)

        //validacion
        let resp = await userCase.validateToken()
        XCTAssertEqual(resp, false)

        //login
        let loginDo = await userCase.loginApp(user: "", password: "")
        XCTAssertEqual(loginDo, true)
        var jwt = CK.loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertNotEqual(jwt, "")

        //Close Session
        await userCase.logout()
        jwt = CK.loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        XCTAssertEqual(jwt, "")
    }

    func testLoginAutoLoginAsincrono() throws {
        var suscriptor = Set<AnyCancellable>()
        let exp = self.expectation(description: "Login Auto ")

        let vm = AppState(loginUseCase: LoginUseCaseFake())
        XCTAssertNotNil(vm)

        vm.$statusLogin
            .sink { completion in
                switch completion {

                case .finished:
                    print("finalizado")
                }
            } receiveValue: { estado in
                print("Recibo estado \(estado)")
                if estado == .success {
                    exp.fulfill()
                }
            }
            .store(in: &suscriptor)

        vm.validateControlLogin()

        self.waitForExpectations(timeout: 10)
    }

    func testUIErrorView() async throws {

        let appStateVM = AppState(loginUseCase: LoginUseCaseFake())
        XCTAssertNotNil(appStateVM)

        appStateVM.statusLogin = .error

        let vc = await ErrorViewController(
            appState: appStateVM, error: "Error Testing")
        XCTAssertNotNil(vc)
    }

    func testUILoginView() throws {
        XCTAssertNoThrow(LoginView())
        let view = LoginView()
        XCTAssertNotNil(view)

        let logo = view.getLogoImageView()
        XCTAssertNotNil(logo)
        let txtUser = view.getEmailView()
        XCTAssertNotNil(txtUser)
        let txtPass = view.getPasswordView()
        XCTAssertNotNil(txtPass)
        let button = view.getLoginButtonView()
        XCTAssertNotNil(button)

        XCTAssertEqual(
            txtUser.placeholder, NSLocalizedString("Email", comment: ""))
        XCTAssertEqual(
            txtPass.placeholder, NSLocalizedString("Password", comment: ""))
        XCTAssertEqual(
            button.titleLabel?.text, NSLocalizedString("Login", comment: ""))

        //la vista esta generada
        let View2 = LoginViewController(
            appState: AppState(loginUseCase: LoginUseCaseFake()))
        XCTAssertNotNil(View2)
        XCTAssertNoThrow(View2.loadView())  //generamos la vista
        XCTAssertNotNil(View2.loginButton)
        XCTAssertNotNil(View2.emailTextfield)
        XCTAssertNotNil(View2.logo)
        XCTAssertNotNil(View2.passwordTextfield)

        //el binding
        XCTAssertNoThrow(View2.bindingUI())

        View2.emailTextfield?.text = "Hola"

        //el boton debe estar desactivado
        XCTAssertEqual(View2.emailTextfield?.text, "Hola")
    }

    func testHeroiewViewModel() async throws {
        let vm = HerosViewModel(useCase: HeroUseCaseFake())
        XCTAssertNotNil(vm)
        XCTAssertEqual(vm.herosData.count, 15)  //debe haber 15 heroes Fake mokeados
    }

    func testHerosUseCase() async throws {
        let caseUser = HeroUseCase(repo: HerosRepositoryFake())
        XCTAssertNotNil(caseUser)

        let data = await caseUser.getHeros(filter: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 15)
    }

    func testHeros_Combine() async throws {
        var suscriptor = Set<AnyCancellable>()
        let exp = self.expectation(description: "Heros get")

        let vm = HerosViewModel(useCase: HeroUseCaseFake())
        XCTAssertNotNil(vm)

        vm.$herosData
            .sink { completion in
                switch completion {

                case .finished:
                    print("finalizado")
                }
            } receiveValue: { data in

                if data.count == 2 {
                    exp.fulfill()
                }
            }
            .store(in: &suscriptor)

        await self.waitForExpectations(timeout: 10)
    }

    func testHeros_Data() async throws {
        let network = NetworkHerosFake()
        XCTAssertNotNil(network)
        let repo = HerosRepository(network: network)
        XCTAssertNotNil(repo)

        let repo2 = HerosRepositoryFake()
        XCTAssertNotNil(repo2)

        let data = await repo.getHeros(filter: "")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 15)

        let data2 = await repo2.getHeros(filter: "")
        XCTAssertNotNil(data2)
        XCTAssertEqual(data2.count, 15)
    }

    func testHeros_Domain() async throws {
        //Models
        let model = HerosModel(
            id: UUID(), favorite: true, description: "des", photo: "url",
            name: "goku")
        XCTAssertNotNil(model)
        XCTAssertEqual(model.name, "goku")
        XCTAssertEqual(model.favorite, true)

        let requestModel = HeroModelRequest(name: "goku")
        XCTAssertNotNil(requestModel)
        XCTAssertEqual(requestModel.name, "goku")
    }

    func testHeros_Presentation() async throws {
        let viewModel = HerosViewModel(useCase: HeroUseCaseFake())
        XCTAssertNotNil(viewModel)

        let view = await HerosTableViewController(
            appState: AppState(loginUseCase: LoginUseCaseFake()),
            viewModel: viewModel)
        XCTAssertNotNil(view)

    }

    // MARK: - Test TransformationsViewModel
    func testTransformationViewModel() async throws {
        let vm = TransformationsViewModel(useCase: TransformationsUseCaseFake())
        XCTAssertNotNil(vm)
        XCTAssertEqual(vm.transformationsData.count, 0)  // Deben haber 14 transformaciones mockeadas
    }

    // MARK: - Test TransformationsUseCase
    func testTransformationsUseCase() async throws {
        let useCase = TransformationsUseCase(
            repo: TransformationsRepositoryFake())
        XCTAssertNotNil(useCase)

        let data = await useCase.getTransformations(
            heroId: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 16)  // Mockeadas desde JSON
    }

    // MARK: - Test Transformations Combine
    func testTransformations_Combine() async throws {
        var suscriptor = Set<AnyCancellable>()
        let exp = self.expectation(description: "Transformations Load")

        let vm = TransformationsViewModel(useCase: TransformationsUseCaseFake())
        XCTAssertNotNil(vm)

        vm.$transformationsData
            .sink { completion in
                switch completion {
                case .finished:
                    print("Finalizado")
                }
            } receiveValue: { data in
                if data.count == 14 {
                    exp.fulfill()
                }
            }
            .store(in: &suscriptor)

        await self.waitForExpectations(timeout: 10)
    }

    // MARK: - Test Transformations Data
    func testTransformations_Data() async throws {
        let network = NetworkTransformationsFake()
        XCTAssertNotNil(network)
        let repo = TransformationsRepository(network: network)
        XCTAssertNotNil(repo)

        let data = await repo.getTransformations(
            heroId: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 16)
    }

    // MARK: - Test Transformations Domain Models
    func testTransformations_Domain() throws {
        let model = TransformationModel(
            id: "17824501-1106-4815-BC7A-BFDCCEE43CC9",
            description: "Goku se transforma en un gran mono...",
            photo:
                "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp",
            name: "1. Oozaru – Gran Mono"
        )
        XCTAssertNotNil(model)
        XCTAssertEqual(model.name, "1. Oozaru – Gran Mono")
        XCTAssertEqual(model.id, "17824501-1106-4815-BC7A-BFDCCEE43CC9")
    }

    // MARK: - Test UI Error Handling
    func testUIErrorHandling() async throws {
        let viewModel = TransformationsViewModel(
            useCase: TransformationsUseCaseFake())
        viewModel.transformationsData = []

        XCTAssertEqual(viewModel.transformationsData.count, 0)  // Sin datos debería estar vacío
    }

    // MARK: - Test NetworkTransformations
    func testNetworkTransformations() async throws {
        let network = NetworkTransformationsFake()
        let data = await network.getTransformations(
            heroId: "D13A40E5-4418-4223-9CE6-D2F9A28EBE94")
        XCTAssertNotNil(data)
        XCTAssertEqual(data.count, 16)
    }
    
    func testHeroDetailViewModelInitialization() {
        let hero = HerosModel(
            id: UUID(),
            favorite: false,
            description: "A test hero",
            photo: "https://example.com/photo.png",
            name: "Test Hero"
        )
        let repository = TransformationsRepositoryFake()
        let viewModel = HeroDetailViewModel(hero: hero, repository: repository)

        XCTAssertNotNil(viewModel)
        XCTAssertFalse(viewModel.isTransformationsButtonVisible)

        let details = viewModel.getHeroDetails()
        XCTAssertEqual(details.name, hero.name)
        XCTAssertEqual(details.description, hero.description)
        XCTAssertEqual(details.photo, hero.photo)
        
    }
    
    func testAppDelegateInitialization() {
        let appDelegate = AppDelegate()
        XCTAssertNotNil(appDelegate)
    }
    
    func testDidFinishLaunchingWithOptions() {
        let appDelegate = AppDelegate()
        let application = UIApplication.shared
        let result = appDelegate.application(application, didFinishLaunchingWithOptions: nil)
        XCTAssertTrue(result) // Verifica que el método devuelve `true`
    }

    func testDidDiscardSceneSessions() {
        let appDelegate = AppDelegate()
        let application = UIApplication.shared
        
        // Llama al método y asegúrate de que no se produce ningún error
        XCTAssertNoThrow(appDelegate.application(application, didDiscardSceneSessions: Set<UISceneSession>()))
    }
        
    func testHerosTableViewCellInitialization() throws {
        // Carga el nib de la celda
        let nib = UINib(nibName: "HerosTableViewCell", bundle: Bundle.main)
        XCTAssertNotNil(nib)
        
        // Instancia la celda
        let cell = nib.instantiate(withOwner: nil, options: nil).first as? HerosTableViewCell
        XCTAssertNotNil(cell)
        
        // Verifica que los IBOutlet estén conectados
        XCTAssertNotNil(cell?.photo)
        XCTAssertNotNil(cell?.title)
    }
    
    func testSetSelectedState() {
        // Instancia la celda de forma manual
        let cell = HerosTableViewCell()
        XCTAssertNotNil(cell)
        
        // Llama al método setSelected para cambiar el estado de la celda
        cell.setSelected(true, animated: false)
        XCTAssertTrue(cell.isSelected) // Verifica que la celda está seleccionada
    }
    
    // MARK: - Test Inicialización
        func testTransformationsViewModelInitialization() {
            let useCase = TransformationsUseCaseFake()
            let viewModel = TransformationsViewModel(useCase: useCase)
            
            XCTAssertNotNil(viewModel)
            XCTAssertTrue(viewModel.transformationsData.isEmpty) // transformationsData debe estar vacío al inicio
        }

        // MARK: - Test FetchTransformations con Datos Mockeados
        func testFetchTransformationsWithData() async {
            let useCase = TransformationsUseCaseFake()
            let viewModel = TransformationsViewModel(useCase: useCase)
            
            let expectation = self.expectation(description: "Transformations Fetched")
            
            // Observar cambios en transformationsData
            viewModel.$transformationsData
                .dropFirst()
                .sink { transformations in
                    XCTAssertFalse(transformations.isEmpty) // Debe contener datos mockeados
                    expectation.fulfill()
                }
                .store(in: &subscriptions)
            
            // Llamar a fetchTransformations
            await viewModel.fetchTransformations(heroName: "TestHero")
            
            // Esperar al cambio en transformationsData
            wait(for: [expectation], timeout: 2.0)
        }
  

        // MARK: - Test Publicación Correcta con Combine
        func testTransformationsDataPublisher() async {
            let useCase = TransformationsUseCaseFake()
            let viewModel = TransformationsViewModel(useCase: useCase)
            
            // Observar cambios en transformationsData
            var receivedData: [[TransformationModel]] = []
            let expectation = self.expectation(description: "Publisher emits data")
            
            viewModel.$transformationsData
                .dropFirst()
                .sink { data in
                    receivedData.append(data)
                    if receivedData.count == 1 {
                        expectation.fulfill()
                    }
                }
                .store(in: &subscriptions)
            
            // Llamar a fetchTransformations
            await viewModel.fetchTransformations(heroName: "TestHero")
            
            // Esperar la emisión de Combine
            wait(for: [expectation], timeout: 2.0)
            
            XCTAssertEqual(receivedData.count, 1) // Debe emitir datos una vez
            XCTAssertFalse(receivedData.first?.isEmpty ?? true) // Datos no deben estar vacíos
        }
    
    // MARK: - Test de Inicialización
        func testDetailHeroViewControllerInitialization() throws {
            let viewController = DetailHeroViewController()
            XCTAssertNotNil(viewController)
        }
        
        // MARK: - Test Configuración de UI
        func testUIElementsAreSetUp() throws {
            let viewController = DetailHeroViewController()
            viewController.loadViewIfNeeded() // Carga la vista

            // Verificar que los elementos están inicializados
            XCTAssertNotNil(viewController.photoImageView)
            XCTAssertNotNil(viewController.nameLabel)
            XCTAssertNotNil(viewController.descriptionLabel)
            XCTAssertNotNil(viewController.transformationsButton)
            XCTAssertNotNil(viewController.scrollView)
            XCTAssertNotNil(viewController.contentView)
        }

        // MARK: - Test de Carga de Datos
        func testLoadHeroData() throws {
            // Crear datos mock del héroe
            let heroMock = HerosModel(
                id: UUID(),
                favorite: false,
                description: "Mock description",
                photo: "https://example.com/image.png",
                name: "Mock Hero"
            )

            // Inicializar el controlador con el héroe
            let viewController = DetailHeroViewController()
            viewController.hero = heroMock
            viewController.loadViewIfNeeded()
            
            // Mock del ViewModel
            viewController.viewModel = HeroDetailViewModel(hero: heroMock)

            // Llamar a la función loadHeroData
            viewController.loadHeroData()

            // Verificar los datos cargados en la UI
            XCTAssertEqual(viewController.nameLabel.text, "Mock Hero")
            XCTAssertEqual(viewController.descriptionLabel.text, "Mock description")
            XCTAssertNotNil(viewController.photoImageView.image) // Si está cargando imágenes remotas, puede ser nil inicialmente
        }
        
        // MARK: - Test de Visibilidad del Botón
        func testTransformationsButtonVisibility() {
            let heroMock = HerosModel(
                id: UUID(),
                favorite: false,
                description: "Mock description",
                photo: "https://example.com/image.png",
                name: "Mock Hero"
            )

            let viewController = DetailHeroViewController()
            viewController.hero = heroMock
            viewController.loadViewIfNeeded()

            // Mock del ViewModel
            let viewModel = HeroDetailViewModel(hero: heroMock)
            viewController.viewModel = viewModel
            
            // Simular la visibilidad del botón
            viewModel.isTransformationsButtonVisible = true
            XCTAssertFalse(viewController.transformationsButton.isHidden)
            
            viewModel.isTransformationsButtonVisible = false
            XCTAssertTrue(viewController.transformationsButton.isHidden)
        }
        
        // MARK: - Test de Acción del Botón
        func testTransformationsButtonAction() {
            let heroMock = HerosModel(
                id: UUID(),
                favorite: false,
                description: "Mock description",
                photo: "https://example.com/image.png",
                name: "Mock Hero"
            )

            let viewController = DetailHeroViewController()
            viewController.hero = heroMock
            viewController.loadViewIfNeeded()

            // Simular navegación
            let navigationController = UINavigationController(rootViewController: viewController)
            viewController.didTapTransformationsButton()

            // Verificar que el nuevo controlador se ha empujado
            XCTAssertEqual(navigationController.viewControllers.count, 2)
            XCTAssertTrue(navigationController.topViewController is TransformationsTableViewController)
        }

    }

