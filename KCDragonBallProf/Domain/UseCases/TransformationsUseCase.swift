import Foundation

protocol TransformationsUseCaseProtocol {
    var repo: TransformationsRepositoryProtocol { get set }
    func getTransformations(heroId: String) async -> [TransformationModel]
}

final class TransformationsUseCase: TransformationsUseCaseProtocol {
    var repo: TransformationsRepositoryProtocol
    
    init(repo: TransformationsRepositoryProtocol = TransformationsRepository(network: NetworkTransformations())) {
        self.repo = repo
    }
    
    func getTransformations(heroId: String) async -> [TransformationModel] {
        return await repo.getTransformations(heroId: heroId)
    }
}

final class TransformationsUseCaseFake: TransformationsUseCaseProtocol {
    var repo: TransformationsRepositoryProtocol
    
    init(repo: TransformationsRepositoryProtocol = TransformationsRepository(network: NetworkTransformationsFake())) {
        self.repo = repo
    }
    
    func getTransformations(heroId: String) async -> [TransformationModel] {
        return await repo.getTransformations(heroId: heroId)
    }
}
