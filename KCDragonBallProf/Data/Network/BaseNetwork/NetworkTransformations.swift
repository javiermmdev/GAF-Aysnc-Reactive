import Foundation
import KcLibraryswift

// Protocol defining the contract for fetching transformations
protocol NetworkTransformationsProtocol {
    // Function to fetch transformations for a specific hero
    // Parameters:
    // - heroId: A `String` representing the unique identifier of the hero
    // Returns: An array of `TransformationModel` containing the transformations
    func getTransformations(heroId: String) async -> [TransformationModel]
}

// Implementation of NetworkTransformationsProtocol for real network operations
final class NetworkTransformations: NetworkTransformationsProtocol {
    // Function to fetch transformations for a specific hero from the API
    func getTransformations(heroId: String) async -> [TransformationModel] {
        var modelReturn = [TransformationModel]() // Array to hold the transformations
        
        // Construct the URL string for the transformations API
        let urlCad: String = "\(ConstantsApp.CONST_API_URL)\(EndPoints.transformations.rawValue)"
        var request: URLRequest = URLRequest(url: URL(string: urlCad)!)
        request.httpMethod = HTTPMethods.post // Set HTTP method to POST
        
        // Encode the hero ID as a JSON body
        request.httpBody = try? JSONEncoder().encode(TransformationModelRequest(id: heroId))
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-Type") // Add content type header
        
        // Load JWT token from KeyChain for authorization
        let JwtToken = KeyChainKC().loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        if let tokenJWT = JwtToken {
            request.addValue("Bearer \(tokenJWT)", forHTTPHeaderField: "Authorization") // Add Authorization header
        }
        
        do {
            // Perform the network request
            let (data, response) = try await URLSession.shared.data(for: request)
            if let resp = response as? HTTPURLResponse {
                // Check for successful HTTP response
                if resp.statusCode == HTTPResponseCodes.SUCCESS {
                    // Decode JSON data into TransformationModel array
                    modelReturn = try JSONDecoder().decode([TransformationModel].self, from: data)
                } else {
                    // Log an error if the HTTP response code is not successful
                    print("Error HTTP: Código \(resp.statusCode)")
                }
            }
        } catch {
            // Handle any errors that occur during the network request or decoding
            print("Error al obtener las transformaciones: \(error)")
        }
        
        return modelReturn // Return the transformations
    }
}

// Fake implementation of NetworkTransformationsProtocol for testing purposes
final class NetworkTransformationsFake: NetworkTransformationsProtocol {
    // Function to fetch transformations for a specific hero using a JSON file
    func getTransformations(heroId: String) async -> [TransformationModel] {
        return getTransformationsFromJson() // Simulate fetching transformations from local JSON
    }
}

// Helper function to load transformations from a JSON file
// Returns: An array of `TransformationModel` parsed from the JSON file
func getTransformationsFromJson() -> [TransformationModel] {
    if let url = Bundle.main.url(forResource: "transformations", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url) // Load JSON data
            let decoder = JSONDecoder() // Create a JSON decoder
            let jsonData = try decoder.decode([TransformationModel].self, from: data) // Decode the data
            return jsonData // Return the parsed transformations
        } catch {
            // Log an error if JSON parsing fails
            print("Error al analizar el JSON de transformaciones: \(error)")
        }
    }
    return [] // Return an empty array if the JSON file is not found or fails to parse
}

// Helper function to provide hardcoded transformation data
// Returns: An array of `TransformationModel` with predefined transformations
func getTransformationsHardcoded() -> [TransformationModel] {
    let transformation1 = TransformationModel(
        id: "17824501-1106-4815-BC7A-BFDCCEE43CC9",
        description: "Cómo todos los Saiyans con cola, Goku es capaz de convertirse en un mono gigante...",
        photo: "https://areajugones.sport.es/wp-content/uploads/2021/05/ozarru.jpg.webp",
        name: "1. Oozaru – Gran Mono"
    )
    
    let transformation2 = TransformationModel(
        id: "9D6012A0-B6A9-4BAB-854D-67904E90CE01",
        description: "La técnica de Kaio-sama permitía a Goku aumentar su poder de forma exponencial...",
        photo: "https://areajugones.sport.es/wp-content/uploads/2017/05/Goku_Kaio-Ken_Coolers_Revenge.jpg",
        name: "2. Kaio-Ken"
    )
    
    return [transformation1, transformation2] // Return hardcoded transformations
}
