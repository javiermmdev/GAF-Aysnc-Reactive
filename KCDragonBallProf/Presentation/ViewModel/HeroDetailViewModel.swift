import Foundation

// ViewModel for managing hero details and related logic
final class HeroDetailViewModel {
    // Repository dependency for fetching hero transformations
    private var transformationsRepository: TransformationsRepositoryProtocol
    
    // Model representing the hero details
    private var hero: HerosModel
    
    // Published property to indicate whether the transformations button should be visible
    @Published var isTransformationsButtonVisible: Bool = false
    
    // Initializer with dependency injection
    // Parameters:
    // - hero: The hero model containing details about the specific hero
    // - repository: A repository protocol for transformations; defaults to a concrete implementation
    init(hero: HerosModel, repository: TransformationsRepositoryProtocol = TransformationsRepository(network: NetworkTransformations())) {
        self.hero = hero  // Assign the provided hero model
        self.transformationsRepository = repository  // Assign the repository
    }
    
    // Asynchronous function to fetch transformations for the hero
    func fetchTransformations() async {
        // Fetch transformations using the repository, passing the hero's unique ID
        let transformations = await transformationsRepository.getTransformations(heroId: hero.id.uuidString)
        
        // Update the visibility of the transformations button on the main thread
        DispatchQueue.main.async {
            self.isTransformationsButtonVisible = !transformations.isEmpty
        }
    }
    
    // Function to retrieve hero details for UI purposes
    // Returns: A tuple containing the hero's name, description, and photo URL
    func getHeroDetails() -> (name: String, description: String, photo: String) {
        return (name: hero.name, description: hero.description, photo: hero.photo)
    }
}
