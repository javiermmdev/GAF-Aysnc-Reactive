import Foundation

// Protocol defining the contract for the Transformations Repository
protocol TransformationsRepositoryProtocol {
    // Asynchronous function to retrieve a list of transformations for a specific hero
    // Parameters:
    // - heroId: A `String` representing the unique identifier of the hero
    // Returns: An array of `TransformationModel` containing all the transformations associated with the hero
    func getTransformations(heroId: String) async -> [TransformationModel]
}
