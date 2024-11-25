import Foundation

final class HerosRepository: HerosRepositoryProtocol {
    private var network: NetworkHerosProtocol
    
    init(network: NetworkHerosProtocol) {
        self.network = network
    }
    
    func getHeros(filter: String) async -> [HerosModel] {
        return await network.getHeros(filter: filter)
    }
}

final class HerosRepositoryFake: HerosRepositoryProtocol {
    private var network: NetworkHerosProtocol
    
    init(network: NetworkHerosProtocol = NetworkHerosFake()) {
        self.network = network
    }
    
    func getHeros(filter: String) async -> [HerosModel] {
        return await network.getHeros(filter: filter)
    }
}
