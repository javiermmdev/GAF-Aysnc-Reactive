import Foundation

final class HerosViewModel: ObservableObject {
    @Published var herosData = [HerosModel]()
    
    private var useCaseHeros: HerosUseCaseProtocol
    
    init(useCase: HerosUseCaseProtocol = HeroUseCase()) {
        self.useCaseHeros = useCase
        Task {
            await getHeros()
        }
    }
    
    func getHeros() async {
        let data = await useCaseHeros.getHeros(filter: "")
        
        DispatchQueue.main.async {
            self.herosData = data
        }
    }
}
