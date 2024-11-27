import Foundation
import Combine

// ViewModel for managing the data and logic related to hero transformations
final class TransformationsViewModel: ObservableObject {
    
    // Published property to notify the UI when transformations data is updated
    @Published var transformationsData: [TransformationModel] = []
    
    // Dependency for fetching transformation data from the use case
    private var useCase: TransformationsUseCaseProtocol
    
    // Set to store Combine subscriptions (useful for future reactive patterns)
    private var subscriptions = Set<AnyCancellable>()

    // Initializer with dependency injection
    // Parameters:
    // - useCase: The protocol defining the transformations use case. Defaults to a concrete implementation.
    init(useCase: TransformationsUseCaseProtocol = TransformationsUseCase()) {
        self.useCase = useCase
    }

    // Asynchronous function to fetch transformations for a specific hero
    // Parameters:
    // - heroName: The name of the hero for whom transformations are being fetched
    func fetchTransformations(heroName: String) async {
        do {
            // Calls the use case to fetch transformations for the given hero name
            let transformations = await useCase.getTransformations(heroId: heroName)
            
            // Updates the published property on the main thread to reflect new data
            DispatchQueue.main.async {
                self.transformationsData = transformations
            }
        }
    }
}
