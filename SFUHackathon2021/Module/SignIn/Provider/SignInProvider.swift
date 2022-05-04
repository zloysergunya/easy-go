import Foundation

class SignInProvider {
    
    func loadSpecifics(completion: @escaping(Result<[Specific], Error>) -> Void) {
        let path = "/get_people_types"
        let URLString = API.basePath + path
        
        HTTPManager(URLString) { data, status in
            if let data = data, let decodableObj = CodableHelper.decode([Specific].self, from: data).decodableObj {
                completion(.success(decodableObj))
            } else if let data = data, let decodableObj = CodableHelper.decode(APIError.self, from: data).decodableObj {
                completion(.failure(ModelError(error: decodableObj, status: status)))
            } else {
                completion(.failure(NSError()))
            }
        }
    }
    
}
