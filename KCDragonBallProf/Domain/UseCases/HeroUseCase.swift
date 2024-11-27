import Foundation

// Protocol defining the contract for the Heroes Use Case
protocol HerosUseCaseProtocol {
    // Property for the repository that manages data operations related to heroes
    var repo: HerosRepositoryProtocol { get set }
    
    // Asynchronous function to fetch a list of heroes
    // Parameters:
    // - filter: A `String` used to filter the heroes by a specific criteria (e.g., name, attributes)
    // Returns: An array of `HerosModel` containing the heroes that match the filter
    func getHeros(filter: String) async -> [HerosModel]
}

// Concrete implementation of the Heroes Use Case
final class HeroUseCase: HerosUseCaseProtocol {
    // Dependency for the repository that handles heroes data
    var repo: HerosRepositoryProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - repo: The repository implementation, defaulting to a production repository
    init(repo: HerosRepositoryProtocol = HerosRepository(network: NetworkHeros())) {
        self.repo = repo
    }
    
    // Function to fetch heroes based on a filter
    // Delegates the call to the repository's `getHeros` method
    func getHeros(filter: String) async -> [HerosModel] {
        return await repo.getHeros(filter: filter)
    }
}

// Fake implementation of the Heroes Use Case for testing purposes
final class HeroUseCaseFake: HerosUseCaseProtocol {
    // Dependency for the repository that provides fake heroes data
    var repo: HerosRepositoryProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - repo: The repository implementation, defaulting to a fake repository
    init(repo: HerosRepositoryProtocol = HerosRepository(network: NetworkHerosFake())) {
        self.repo = repo
    }
    
    // Function to fetch fake heroes based on a filter
    // Delegates the call to the fake repository's `getHeros` method
    func getHeros(filter: String) async -> [HerosModel] {
        return await repo.getHeros(filter: filter)
    }
}
