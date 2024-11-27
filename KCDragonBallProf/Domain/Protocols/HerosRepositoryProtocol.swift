import Foundation

// Protocol defining the contract for the Heroes Repository
protocol HerosRepositoryProtocol {
    // Asynchronous function to retrieve a list of heroes
    // Parameters:
    // - filter: A `String` used to filter the list of heroes (e.g., by name or attributes)
    // Returns: An array of `HerosModel`, representing the heroes that match the filter criteria
    func getHeros(filter: String) async -> [HerosModel]
}
