
import Foundation

protocol TransformationsRepositoryProtocol {
    func getTransformations(heroId: String) async -> [TransformationModel]
}
