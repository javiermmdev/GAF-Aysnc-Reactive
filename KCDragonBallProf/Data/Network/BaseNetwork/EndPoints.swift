import Foundation

// Enumeration for managing API endpoint paths
enum EndPoints: String {
    // Endpoint for user login
    case login = "/api/auth/login"
    // Endpoint for retrieving all heroes
    case heros = "/api/heros/all"
    // Endpoint for retrieving hero transformations
    case transformations = "/api/heros/tranformations"
}
