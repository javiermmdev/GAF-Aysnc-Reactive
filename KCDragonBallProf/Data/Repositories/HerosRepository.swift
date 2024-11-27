import Foundation

// Concrete implementation of the Heroes Repository
final class HerosRepository: HerosRepositoryProtocol {
    // Dependency for the network layer that handles fetching hero data
    private var network: NetworkHerosProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - network: The network layer implementation used to fetch hero data
    init(network: NetworkHerosProtocol) {
        self.network = network
    }
    
    // Asynchronous function to fetch a list of heroes
    // Parameters:
    // - filter: A `String` used to filter the heroes (e.g., by name or attributes)
    // Returns: An array of `HerosModel` containing the heroes that match the filter
    func getHeros(filter: String) async -> [HerosModel] {
        // Delegates the fetching process to the network layer
        return await network.getHeros(filter: filter)
    }
}

// Fake implementation of the Heroes Repository for testing purposes
final class HerosRepositoryFake: HerosRepositoryProtocol {
    // Dependency for the fake network layer that simulates hero data fetching
    private var network: NetworkHerosProtocol
    
    // Initializer with dependency injection
    // Parameters:
    // - network: The fake network layer implementation, defaulting to `NetworkHerosFake`
    init(network: NetworkHerosProtocol = NetworkHerosFake()) {
        self.network = network
    }
    
    // Asynchronous function to simulate fetching a list of heroes
    // Parameters:
    // - filter: A `String` used to filter the heroes (not necessarily used in the fake implementation)
    // Returns: An array of `HerosModel` simulating the heroes matching the filter
    func getHeros(filter: String) async -> [HerosModel] {
        // Delegates the fetching process to the fake network layer
        return await network.getHeros(filter: filter)
    }
}
