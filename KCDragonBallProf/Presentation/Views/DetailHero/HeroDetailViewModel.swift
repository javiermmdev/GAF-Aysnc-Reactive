import Foundation

final class HeroDetailViewModel {
    private var transformationsRepository: TransformationsRepositoryProtocol
    private var hero: HerosModel
    
    @Published var isTransformationsButtonVisible: Bool = false
    
    init(hero: HerosModel, repository: TransformationsRepositoryProtocol = TransformationsRepository(network: NetworkTransformations())) {
        self.hero = hero
        self.transformationsRepository = repository
    }
    
    func fetchTransformations() async {
        // Verificar si hay transformaciones para el héroe
        let transformations = await transformationsRepository.getTransformations(heroId: hero.id.uuidString)
        DispatchQueue.main.async {
            self.isTransformationsButtonVisible = !transformations.isEmpty
        }
    }
    
    func getHeroDetails() -> (name: String, description: String, photo: String) {
        return (name: hero.name, description: hero.description, photo: hero.photo)
    }
}
