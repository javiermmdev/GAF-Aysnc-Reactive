import Foundation

// Protocol defining the contract for the Transformations Use Case
protocol TransformationsUseCaseProtocol {
    // Property for the repository that handles data operations related to transformations
    var repo: TransformationsRepositoryProtocol { get set }
    
    // Asynchronous function to fetch transformations for a specific hero
    // Parameters:
    // - heroId: A `String` representing the unique identifier of the hero
    // Returns: An array of `TransformationModel` containing the hero's transformations
    func getTransformations(heroId: String) async -> [TransformationModel]
}

// Concrete implementation of the Transformations Use Case
final class TransformationsUseCase: TransformationsUseCaseProtocol {
    // Repository dependency for fetching transformations
    var repo: TransformationsRepositoryProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - repo: The repository implementation, defaulting to the production repository
    init(repo: TransformationsRepositoryProtocol = TransformationsRepository(network: NetworkTransformations())) {
        self.repo = repo
    }
    
    // Function to fetch transformations for a given hero
    // This calls the repository's method and returns the result
    func getTransformations(heroId: String) async -> [TransformationModel] {
        return await repo.getTransformations(heroId: heroId)
    }
}

// Fake implementation of the Transformations Use Case for testing
final class TransformationsUseCaseFake: TransformationsUseCaseProtocol {
    // Repository dependency for fetching fake transformations
    var repo: TransformationsRepositoryProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - repo: The repository implementation, defaulting to a fake repository
    init(repo: TransformationsRepositoryProtocol = TransformationsRepository(network: NetworkTransformationsFake())) {
        self.repo = repo
    }
    
    // Function to fetch fake transformations for a given hero
    // This calls the fake repository's method and returns the result
    func getTransformations(heroId: String) async -> [TransformationModel] {
        return await repo.getTransformations(heroId: heroId)
    }
}
