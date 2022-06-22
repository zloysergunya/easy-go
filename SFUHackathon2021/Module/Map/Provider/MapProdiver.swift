import Foundation

class MapProdiver {
    
    func loadPoints(completion: @escaping(Result<[Feature], Error>) -> Void) {
        let path = "/points"
        let URLString = API.basePath + path
        
        HTTPManager(URLString) { data, status in
            if let data = data, let decodableObj = CodableHelper.decode(APIFeatures.self, from: data).decodableObj {
                completion(.success(decodableObj.features))
            } else if let data = data, let decodableObj = CodableHelper.decode(APIError.self, from: data).decodableObj {
                completion(.failure(ModelError(error: decodableObj, status: status)))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
    
    func loadElements(completion: @escaping(Result<[Element], Error>) -> Void) {
        let path = "/get_chars"
        let URLString = API.basePath + path
        
        HTTPManager(URLString) { data, status in
            if let data = data, let decodableObj = CodableHelper.decode([Element].self, from: data).decodableObj {
                completion(.success(decodableObj))
            } else if let data = data, let decodableObj = CodableHelper.decode(APIError.self, from: data).decodableObj {
                completion(.failure(ModelError(error: decodableObj, status: status)))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
    
    func getRoute(pointFrom: [Double], pointTo: [Double], completion: @escaping(Result<[Points], Error>) -> Void) {
        let URLString = "https://graphhopper.com/api/1/route?point=\("\(pointFrom[0]),\(pointFrom[1])")&point=\("\(pointTo[0]),\(pointTo[1])")&profile=foot&locale=ru&debug=\(true)&points_encoded=\(false)&key=\(Constants.graphhopperAPIKey)"
        let params: [String:Any] = [:]
        
        HTTPManager(URLString, params: params) { data, status in
            if let data = data, let decodableObj = CodableHelper.decode(APIPaths.self, from: data).decodableObj {
                completion(.success(decodableObj.paths))
            } else if let data = data, let decodableObj = CodableHelper.decode(APIError.self, from: data).decodableObj {
                completion(.failure(ModelError(error: decodableObj, status: status)))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
    
}
