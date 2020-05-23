import Alamofire

enum APIResponse<T: Codable> {
    case success (data: T)
    case error (code: Int?, message: String?)
}

protocol APIRequesting: ConnectionChecking {
    associatedtype ResponseModel: Codable
    
    var httpMethod: HTTPMethod { get }
    var baseURL: String { get }
    var requestURL: String { get }
    var parameters: Any? { get }
}

extension APIRequesting {
    var baseURL: String { "https://myfridge-b9707.firebaseio.com/groups/" }
    
    var headers: HTTPHeaders { [:] }
}

extension APIRequesting {
    
    @discardableResult
    func execute(completion: ((_ response: APIResponse<ResponseModel>) -> Void)?) -> URLSessionTask? {
        let errorCompletion = {
            completion?(.error(code: nil, message: nil))
        }
        
        if !isConnected() {
            errorCompletion()
            return nil
        }
        
        guard var components = URLComponents(string: baseURL + requestURL) else {
            errorCompletion()
            return nil
        }
        
        if httpMethod == .get {
            var items: [URLQueryItem] = []
            
            (parameters as? [String : Any])?.forEach { param in
                let array = param.value as? [Any]
                let mapped = array?.compactMap { String(describing: $0) }
                
                let item: URLQueryItem
                
                if let stringsArray = mapped, stringsArray.count > 0 {
                    item = URLQueryItem(name: param.key, value: stringsArray.joined(separator: ","))
                    items.append(item)
                } else if mapped == nil {
                    item = URLQueryItem(name: param.key, value: "\(param.value)")
                    items.append(item)
                }

            }
            
            // Force encode "+", because the server sees this character as the control character
            var cs = CharacterSet.urlQueryAllowed
            cs.remove("+")
            
            components.percentEncodedQuery = items.compactMap { item -> String? in
                guard
                    let name = item.name.addingPercentEncoding(withAllowedCharacters: cs),
                    let value = item.value?.addingPercentEncoding(withAllowedCharacters: cs)
                else { return nil }
                
                return "\(name)=\(value)"
            }.joined(separator: "&")
        }
        
        guard
            let url = components.url,
            var request = try? URLRequest(url: url, method: httpMethod, headers: self.headers)
        else {
            errorCompletion()
            return nil
        }
        
        if httpMethod != .get, let params = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params)
            } catch {
                Logger.warning("Json serialization error: \(error.localizedDescription)")
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            self.handleResponse(response as? HTTPURLResponse, data: data, error: error) { apiResponse in
                DispatchQueue.main.async {
                    completion?(apiResponse)
                }
            }
        }
        task.resume()
        
        return task
    }
   
    
    // MARK: - Requests handling.
    
    private func handleResponse(_ response: HTTPURLResponse?, data: Data?, error: Error?, then completion: ((_ response: APIResponse<ResponseModel>) -> Void)?) {
        guard let response = response, let data = data, error == nil else {
            Logger.error("Failed to get response or data.")
            completion?(.error(code: nil, message: error?.localizedDescription))
            return
        }
        
        let httpCode = response.statusCode
        
        switch httpCode {
        
        case 200...299:
            
            let message: String
            
            do {
                let model = try JSONDecoder().decode(ResponseModel.self, from: data)
                completion?(.success(data: model))
                return
            } catch let DecodingError.dataCorrupted(context) {
                message = "\(context)"
            } catch let DecodingError.keyNotFound(key, context) {
                message = "Key '\(key)' not found: \(context.debugDescription)\nCoding path: \(context.codingPath)"
            } catch let DecodingError.valueNotFound(value, context) {
                message = "Value '\(value)' not found: \(context.debugDescription)\nCoding path: \(context.codingPath)"
            } catch let DecodingError.typeMismatch(type, context)  {
                message = "Type '\(type)' not found: \(context.debugDescription)\nCoding path: \(context.codingPath)"
            } catch {
                message = "Parse error: \(error)"
            }
            
            Logger.error("Failed to parse response.\nStatus code \(httpCode).\n\(message)")
            
            completion?(.error(code: httpCode, message: message))
            
        case 400...499:
            Logger.error("Request error – \(error?.localizedDescription ?? "") \(httpCode)")
            completion?(.error(code: httpCode, message: error?.localizedDescription))
            
            
        default:
            Logger.error("Server error – \(error?.localizedDescription ?? "") \(httpCode)")
            completion?(.error(code: httpCode, message: error?.localizedDescription))
        }
    }
    
}

