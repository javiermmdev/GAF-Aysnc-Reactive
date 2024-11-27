import Foundation
import KcLibraryswift

// Protocol defining the contract for fetching hero data
protocol NetworkHerosProtocol {
    // Asynchronous function to retrieve heroes based on a filter
    // Parameters:
    // - filter: A `String` used to filter the list of heroes (e.g., by name)
    // Returns: An array of `HerosModel` containing the filtered heroes
    func getHeros(filter: String) async -> [HerosModel]
}

// Implementation of NetworkHerosProtocol for real network interactions
final class NetworkHeros: NetworkHerosProtocol {
    // Function to fetch heroes from a remote server
    func getHeros(filter: String) async -> [HerosModel] {
        var modelReturn = [HerosModel]() // Array to store the fetched heroes
        
        // Construct the URL for the heroes API
        let urlCad: String = "\(ConstantsApp.CONST_API_URL)\(EndPoints.heros.rawValue)"
        var request: URLRequest = URLRequest(url: URL(string: urlCad)!)
        request.httpMethod = HTTPMethods.post // Set HTTP method to POST
        
        // Encode the filter as a JSON body
        request.httpBody = try? JSONEncoder().encode(HeroModelRequest(name: filter))
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-type") // Set content type
        
        // Load JWT token from the KeyChain for authorization
        let JwtToken = KeyChainKC().loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        if let tokenJWT = JwtToken {
            request.addValue("Bearer \(tokenJWT)", forHTTPHeaderField: "Authorization") // Add token to header
        }
        
        do {
            // Perform the network request
            let (data, response) = try await URLSession.shared.data(for: request)
            if let resp = response as? HTTPURLResponse {
                // Check if the response status code indicates success
                if resp.statusCode == HTTPResponseCodes.SUCCESS {
                    // Decode the JSON data into an array of HerosModel
                    modelReturn = try! JSONDecoder().decode([HerosModel].self, from: data)
                }
            }
        } catch {
            // Handle errors silently in this implementation
        }
        return modelReturn // Return the fetched heroes
    }
}

// Fake implementation of NetworkHerosProtocol for testing
final class NetworkHerosFake: NetworkHerosProtocol {
    // Function to fetch heroes from a local JSON file
    func getHeros(filter: String) async -> [HerosModel] {
        return getHerosFromJson() // Simulate fetching heroes from a JSON file
    }
}

// Helper function to load heroes from a local JSON file
// Returns: An array of `HerosModel` parsed from the JSON file
func getHerosFromJson() -> [HerosModel] {
    if let url = Bundle.main.url(forResource: "heros", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url) // Load the JSON file
            let decoder = JSONDecoder() // Create a JSON decoder
            let jsonData = try decoder.decode([HerosModel].self, from: data) // Decode the data
            return jsonData // Return the parsed heroes
        } catch {
            print("error:\(error)") // Print any decoding errors
        }
    }
    return [] // Return an empty array if the file or decoding fails
}

// Helper function to provide hardcoded hero data
// Returns: An array of `HerosModel` containing predefined heroes
func getHerosHardcoded() -> [HerosModel] {
    let model1 = HerosModel(
        id: UUID(),
        favorite: true,
        description: """
            Sobran las presentaciones cuando se habla de Goku. El Saiyan fue enviado al planeta Tierra, pero hay dos versiones sobre el origen del personaje. Según una publicación especial, cuando Goku nació midieron su poder y apenas llegaba a dos unidades, siendo el Saiyan más débil. Aun así se pensaba que le bastaría para conquistar el planeta. Sin embargo, la versión más popular es que Freezer era una amenaza para su planeta natal y antes de que fuera destruido, se envió a Goku en una incubadora para salvarle.
        """,
        photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/goku1.jpg?width=300",
        name: "Goku"
    )
    
    let model2 = HerosModel(
        id: UUID(),
        favorite: true,
        description: """
            Vegeta es todo lo contrario. Es arrogante, cruel y despreciable. Quiere conseguir las bolas de Dragón y se enfrenta a todos los protagonistas, matando a Yamcha, Ten Shin Han, Piccolo y Chaos. Es despreciable porque no duda en matar a Nappa, quien entonces era su compañero, como castigo por su fracaso. Tras el intenso entrenamiento de Goku, el guerrero se enfrenta a Vegeta y estuvo a punto de morir. Lejos de sobreponerse, Vegeta huye del planeta Tierra sin saber que pronto tendrá que unirse a los que considera sus enemigos.
        """,
        photo: "https://cdn.alfabetajuega.com/alfabetajuega/2020/12/vegetita.jpg?width=300",
        name: "Vegeta"
    )

    return [model1, model2] // Return the hardcoded heroes
}
