import Foundation

// Concrete implementation of the Transformations Repository
final class TransformationsRepository: TransformationsRepositoryProtocol {
    // Dependency for the network layer responsible for fetching transformation data
    private var network: NetworkTransformationsProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - network: The network layer implementation used to fetch transformations
    init(network: NetworkTransformationsProtocol) {
        self.network = network
    }
    
    // Asynchronous function to fetch transformations for a specific hero
    // Parameters:
    // - heroId: A `String` representing the unique identifier of the hero
    // Returns: An array of `TransformationModel` containing the hero's transformations
    func getTransformations(heroId: String) async -> [TransformationModel] {
        // Delegates the fetching process to the network layer
        return await network.getTransformations(heroId: heroId)
    }
}

// Fake implementation of the Transformations Repository for testing purposes
final class TransformationsRepositoryFake: TransformationsRepositoryProtocol {
    // Dependency for the fake network layer responsible for simulating transformation data fetching
    private var network: NetworkTransformationsProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - network: The fake network layer implementation, defaulting to `NetworkTransformationsFake`
    init(network: NetworkTransformationsProtocol = NetworkTransformationsFake()) {
        self.network = network
    }
    
    // Asynchronous function to simulate fetching transformations for a specific hero
    // Parameters:
    // - heroId: A `String` representing the unique identifier of the hero
    // Returns: An array of `TransformationModel` simulating the hero's transformations
    func getTransformations(heroId: String) async -> [TransformationModel] {
        // Delegates the simulated fetching process to the fake network layer
        return await network.getTransformations(heroId: heroId)
    }
}
