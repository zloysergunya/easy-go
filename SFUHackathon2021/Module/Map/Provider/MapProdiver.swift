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
        let path = "/get_route"
        let URLString = API.basePath + path
        let params: [String:Any] = ["point_from": "\(pointFrom[0]),\(pointFrom[1])",
                                    "point_to": "\(pointTo[0]),\(pointTo[1])",
                                    "user_config": UserSettings.specific as Any]
        
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
