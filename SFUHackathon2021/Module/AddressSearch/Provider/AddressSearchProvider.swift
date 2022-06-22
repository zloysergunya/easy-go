import Foundation

class AddressSearchProvider {
    
    func search(query: String, completion: @escaping(Result<[Hit], Error>) -> Void) {
        let URLString = "https://graphhopper.com/api/1/geocode"
        let params: [String:Any] = ["q": query,
                                    "type": "json",
                                    "locale": "ru",
                                    "debug:": true,
                                    "key": Constants.graphhopperAPIKey]
        
        HTTPManager(URLString, method: "GET", params: params) { data, status in
            if let data = data, let decodableObj = CodableHelper.decode(APIHits.self, from: data).decodableObj {
                completion(.success(decodableObj.hits))
            } else if let data = data, let decodableObj = CodableHelper.decode(APIError.self, from: data).decodableObj {
                completion(.failure(ModelError(error: decodableObj, status: status)))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
    
}
