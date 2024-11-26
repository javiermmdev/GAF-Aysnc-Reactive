import Foundation
import Combine

final class TransformationsViewModel: ObservableObject {
    @Published var transformationsData: [TransformationModel] = []
    private var useCase: TransformationsUseCaseProtocol
    private var subscriptions = Set<AnyCancellable>()

    init(useCase: TransformationsUseCaseProtocol = TransformationsUseCase()) {
        self.useCase = useCase
    }

    func fetchTransformations(heroName: String) async {
        do {
            let transformations = await useCase.getTransformations(heroId: heroName)
            
            // Update transformationsData on the main thread
            DispatchQueue.main.async {
                self.transformationsData = transformations
            }
        }
    }
}
