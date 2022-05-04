import Foundation

class API {
    static var basePath = "https://my-api43.herokuapp.com/api"
    static var loggingEnabled = false
}

func HTTPManager(_ url: String = API.basePath,
                 method: String = "GET",
                 params: [String:Any?] = [:],
                 constants: [String:Any?] = [:],
                 completion: @escaping (Data?, _ status: Int) -> Void) {
    var urn: String = ""
    var timeout = 15.0
    let body = NSMutableData()
    let values = params
    var contentType: String? = nil
    
    switch method {
    case "GET", "DELETE", "HEAD":
        if values.count > 0 {
            var toString: [String] = []
            values.forEach {
                toString.append("\($0)=\($1 ?? "")")
            }
            urn = "?" + toString.joined(separator: "&")
        }
    case "JSON":
        contentType = "application/json"
        if let json = params.jsonString() {
            body.appendString(json)
        }
        
    default:
        timeout = 30
        if values.count > 0 {
            let boundary = "iOS-\(UUID().uuidString)"
            contentType = "multipart/form-data; boundary=\(boundary)"
            for (key, value) in values {
                if let value = value {
                    body.appendString("--\(boundary)\r\nContent-Disposition: form-data; name=\"")
                    body.appendString("\(key)\"\r\n\r\n\(value)\r\n")
                }
            }
            body.appendString("--".appending(boundary.appending("--")))
        }
    }
    
    if API.loggingEnabled { print("\nHTTPRequest[\(method)]:\n\(url)\(urn)") }
    
    if let uri = URL(string: (url + urn).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!) {
        let session = URLSession.shared
        var request = URLRequest(url: uri)
        
        if let mime = contentType {
            if API.loggingEnabled { print("\nЗАПРОС К СЕРВЕРУ\n\(String(data: body as Data, encoding: String.Encoding.utf8) ?? "П У С Т О")") }
            request.setValue(mime, forHTTPHeaderField: "Content-Type")
            request.setValue("keep-alive", forHTTPHeaderField: "Connection")
            request.httpBody = body as Data
            request.timeoutInterval = timeout
        }
        
        request.httpMethod = method == "JSON" ? "POST" : method
        
        let load = session.dataTask(with: request, completionHandler: { data, response, error in
            let status = response?.getStatus ?? 1000
            if API.loggingEnabled { print("\nОТВЕТ СЕРВЕРА СО СТАТУСОМ: \(status)\n\(String(data: data ?? Data(), encoding: String.Encoding.utf8) ?? "ПУСТОЕ")\n") }
            
            DispatchQueue.main.async {
                completion(data, status)
            }
        })
        load.resume()
    }
}

extension Dictionary {
    func jsonString(prettify: Bool = false) -> String? {
        guard JSONSerialization.isValidJSONObject(self) else { return nil }
        let options = (prettify == true) ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions()
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: options) else { return nil }
        return String(data: jsonData, encoding: .utf8)
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
        append(data!)
    }
}

extension URLResponse {
    var getStatus: Int? {
        get {
            if let httpResponse = self as? HTTPURLResponse {
                return httpResponse.statusCode
            }
            return nil
        }
    }
}
