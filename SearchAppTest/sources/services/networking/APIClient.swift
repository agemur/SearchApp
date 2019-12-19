

import Foundation

//This class provides an interface for executing server API requests.
class APIClient {
    
}


extension APIClient {
    public static func request<T: Decodable>(
        route: URLRequestConvertible,
        completion: @escaping (T?, Error?) -> Void) {
        var baseURL = route.baseURL
        baseURL.append(route.path)
        guard let url = URL(string: baseURL) else {
            fatalError("ServerConstants not configure")
        }

        guard let request = route.request(url: url) else {
            print("Request error")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    completion(nil, error)
                    print("Client error! \(error.localizedDescription)")
                }
                completion(nil, NSError.internalServerError)
                return
            }

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode),
                let str = String(data: data, encoding: .utf8)?.replacingOccurrences(of: "\n", with: ""),
            let clearData = str.data(using: .utf8)
                else {
                completion(nil, NSError.undefinedServerError)
                print("Server error!")
                return
            }

            do {
                let result = try JSONDecoder().decode(T.self, from: clearData)
                completion(result, nil)
            } catch {
                completion(nil, NSError.serverDataError)
                print("JSON error: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}
