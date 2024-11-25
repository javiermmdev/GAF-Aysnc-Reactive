
import Foundation

struct TransformationModel: Codable {
    let id: String
    let description: String
    let photo: String
    let name: String
}

struct TransformationModelRequest: Codable {
    let id: String
}
