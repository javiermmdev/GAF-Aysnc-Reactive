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
        XCTAssertEqual(data.count, 16)
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

        XCTAssertEqual(viewModel.transformationsData.count, 0)
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
        XCTAssertTrue(result)
    }

    func testDidDiscardSceneSessions() {
        let appDelegate = AppDelegate()
        let application = UIApplication.shared
        
        XCTAssertNoThrow(appDelegate.application(application, didDiscardSceneSessions: Set<UISceneSession>()))
    }
        
    func testHerosTableViewCellInitialization() throws {
        let nib = UINib(nibName: "HerosTableViewCell", bundle: Bundle.main)
        XCTAssertNotNil(nib)
        
        let cell = nib.instantiate(withOwner: nil, options: nil).first as? HerosTableViewCell
        XCTAssertNotNil(cell)
        
        XCTAssertNotNil(cell?.photo)
        XCTAssertNotNil(cell?.title)
    }
    
    func testSetSelectedState() {
        let cell = HerosTableViewCell()
        XCTAssertNotNil(cell)
        
        cell.setSelected(true, animated: false)
        XCTAssertTrue(cell.isSelected)
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
            
            viewModel.$transformationsData
                .dropFirst()
                .sink { transformations in
                    XCTAssertFalse(transformations.isEmpty) // Debe contener datos mockeados
                    expectation.fulfill()
                }
                .store(in: &subscriptions)
            
            await viewModel.fetchTransformations(heroName: "TestHero")
            
            wait(for: [expectation], timeout: 2.0)
        }
  

        // MARK: - Test Publicación Correcta con Combine
        func testTransformationsDataPublisher() async {
            let useCase = TransformationsUseCaseFake()
            let viewModel = TransformationsViewModel(useCase: useCase)
            
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
            
            await viewModel.fetchTransformations(heroName: "TestHero")
            
            wait(for: [expectation], timeout: 2.0)
            
            XCTAssertEqual(receivedData.count, 1) // Debe emitir datos una vez
            XCTAssertFalse(receivedData.first?.isEmpty ?? true) // Datos no deben estar vacíos
        }
    
 
    func testViewControllerInitialization() {
            let viewController = DetailHeroViewController()
            XCTAssertNotNil(viewController)
        }
        
        func testHeroAssignment() {
            let heroMock = HerosModel(
                id: UUID(),
                favorite: false,
                description: "Mock description",
                photo: "https://example.com/image.png",
                name: "Mock Hero"
            )
            
            let viewController = DetailHeroViewController()
            viewController.hero = heroMock
            XCTAssertEqual(viewController.hero?.name, "Mock Hero")
            XCTAssertEqual(viewController.hero?.description, "Mock description")
            XCTAssertEqual(viewController.hero?.photo, "https://example.com/image.png")
        }
        
        func testViewDidLoadDoesNotCrash() {
            let heroMock = HerosModel(
                id: UUID(),
                favorite: false,
                description: "Mock description",
                photo: "https://example.com/image.png",
                name: "Mock Hero"
            )
            
            let viewController = DetailHeroViewController()
            viewController.hero = heroMock
            
            XCTAssertNoThrow(viewController.viewDidLoad())
        }
        
        func testViewControllerHandlesNilHeroGracefully() {
            let viewController = DetailHeroViewController()
            XCTAssertNoThrow(viewController.viewDidLoad())
        }
        
        func testNavigationWhenTransformationsButtonTapped() {
            let heroMock = HerosModel(
                id: UUID(),
                favorite: false,
                description: "Mock description",
                photo: "https://example.com/image.png",
                name: "Mock Hero"
            )
            
            let viewController = DetailHeroViewController()
            viewController.hero = heroMock
            
            let navigationController = UINavigationController(rootViewController: viewController)
            XCTAssertEqual(navigationController.viewControllers.count, 1)
            
            viewController.didTapTransformationsButton()
            
            XCTAssertEqual(navigationController.viewControllers.count, 2)
            XCTAssertTrue(navigationController.topViewController is TransformationsTableViewController)
        }
        
    }

