import Foundation
import KcLibraryswift

protocol NetworkTransformationsProtocol {
    func getTransformations(heroId: String) async -> [TransformationModel]
}

final class NetworkTransformations: NetworkTransformationsProtocol {
    func getTransformations(heroId: String) async -> [TransformationModel] {
        var modelReturn = [TransformationModel]()
        
        let urlCad: String = "\(ConstantsApp.CONST_API_URL)\(EndPoints.transformations.rawValue)"
        var request: URLRequest = URLRequest(url: URL(string: urlCad)!)
        request.httpMethod = HTTPMethods.post
        request.httpBody = try? JSONEncoder().encode(TransformationModelRequest(id: heroId))
        request.addValue(HTTPMethods.content, forHTTPHeaderField: "Content-Type")
        
        let JwtToken = KeyChainKC().loadKC(key: ConstantsApp.CONST_TOKEN_ID_KEYCHAIN)
        if let tokenJWT = JwtToken {
            request.addValue("Bearer \(tokenJWT)", forHTTPHeaderField: "Authorization") // Token
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let resp = response as? HTTPURLResponse {
                if resp.statusCode == HTTPResponseCodes.SUCCESS {
                    modelReturn = try JSONDecoder().decode([TransformationModel].self, from: data)
                } else {
                    print("Error HTTP: Código \(resp.statusCode)")
                }
            }
        } catch {
            print("Error al obtener las transformaciones: \(error)")
        }
        
        return modelReturn
    }
}

final class NetworkTransformationsFake: NetworkTransformationsProtocol {
    func getTransformations(heroId: String) async -> [TransformationModel] {
        return getTransformationsFromJson()
    }
}

func getTransformationsFromJson() -> [TransformationModel] {
    if let url = Bundle.main.url(forResource: "transformations", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([TransformationModel].self, from: data)
            return jsonData
        } catch {
            print("Error al analizar el JSON de transformaciones: \(error)")
        }
    }
    return []
}

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
    
    return [transformation1, transformation2]
}
