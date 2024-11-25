import Foundation

final class TransformationsRepository: TransformationsRepositoryProtocol {
    private var network: NetworkTransformationsProtocol
    
    init(network: NetworkTransformationsProtocol) {
        self.network = network
    }
    
    func getTransformations(heroId: String) async -> [TransformationModel] {
        return await network.getTransformations(heroId: heroId)
    }
}

final class TransformationsRepositoryFake: TransformationsRepositoryProtocol {
    private var network: NetworkTransformationsProtocol
    
    init(network: NetworkTransformationsProtocol = NetworkTransformationsFake()) {
        self.network = network
    }
    
    func getTransformations(heroId: String) async -> [TransformationModel] {
        return await network.getTransformations(heroId: heroId)
    }
}
