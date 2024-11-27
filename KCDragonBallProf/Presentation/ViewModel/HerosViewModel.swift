import Foundation

// ViewModel class for managing hero-related data in the application
final class HerosViewModel: ObservableObject {
    // Published property to notify the UI of updates to the hero data
    @Published var herosData = [HerosModel]()
    
    // Dependency for interacting with the hero-related use case
    private var useCaseHeros: HerosUseCaseProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - useCase: Default implementation is `HeroUseCase`
    //   Allows flexibility for testing or swapping implementations
    init(useCase: HerosUseCaseProtocol = HeroUseCase()) {
        self.useCaseHeros = useCase
        // Asynchronously fetch hero data upon initialization
        Task {
            await getHeros()
        }
    }
    
    // Asynchronous function to fetch heroes data
    func getHeros() async {
        // Calls the `getHeros` method from the use case with no filter
        let data = await useCaseHeros.getHeros(filter: "")
        
        // Ensures UI updates occur on the main thread
        DispatchQueue.main.async {
            self.herosData = data  // Updates the published property with new data
        }
    }
}
